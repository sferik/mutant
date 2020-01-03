# frozen_string_literal: true

module Mutant
  # Class to capture warnings generated by Kernel#warn and Ruby itself.
  #
  # @example
  #   capture = Mutant::Warnings.new(Warning)
  #
  #   # Note that this test case shows we can capture warnings generated from C
  #   def ruby_warning
  #     Class.new do
  #       undef :initialize
  #     end
  #   end
  #
  #   messages = capture.call do
  #     ruby_warning
  #   end
  #
  #   messages # => ["some_file.rb:44: warning: undefining `initialize' may cause serious problems\n"]
  #
  # Note this API is fundamentally impure:
  #
  # * Unlike almost all of classes in the mutant code base it has internal
  #   mutable state
  # * Its therefore NOT thread safe
  # * And worst: Each instance, even after its not referenced anymore by user
  #   code: Leaks permanent global state as instances of this class hook
  #   itself into the `Warning` module.
  #
  # So ideally only make *one* instance, and re-use it.
  #
  # Also note, a more canonical implementation would prepend modules and simply
  # call `super` in the event the capture is disabled. This sadly does not
  # work as it would inference with various bad players in the ruby ecosystem
  # that do not adhere to the semantics outlined in the documentation.
  #
  # See: https://ruby-doc.org/core-2.6.3/Warning.html
  #
  # For example in case rubygems is active it adds its own hook to warnings,
  # that would in case of the super implementation cause infinite recursion.
  #
  # Reproduction for this case is as simple as:
  #
  # ```
  # require 'rubygems'
  #
  # module Warning
  #   def warn(*)
  #     super
  #   end
  # end
  # ```
  #
  # For that reason we do have to use the original method capture to dispatch
  # in disabled state.
  #
  # ignore :reek:RepeatedConditional
  class Warnings
    # Error raised when warning capture is used recursively
    class RecursiveUseError < RuntimeError; end

    # Initialize object
    #
    # @param [Module] warning
    #   the module to integrate against
    #
    # @return [undefined]
    def initialize(warning)
      @disabled = true
      @messages = []
      @original = warning.public_method(:warn)

      capture = method(:capture)
      warning.module_eval do
        module_function define_method(:warn, &capture)
      end
    end

    # Run a block with warning collection enabled
    #
    # @return [Array<String>]
    def call
      assert_no_recursion
      @disabled = nil
      yield
      IceNine.deep_freeze(@messages.dup)
    ensure
      @disabled = true
      @messages.clear
    end

  private

    # Hook called when capturing a warning
    #
    # @return [undefined]
    def capture(*arguments)
      if @disabled
        @original.call(*arguments)
      else
        @messages << arguments
      end
    end

    # Assert warnings capture does not call itself
    #
    # Its currently not supported nor intended to be supported.
    def assert_no_recursion
      fail RecursiveUseError unless @disabled
    end
  end # Warnings
end # Mutant
