# encoding: utf-8

require 'stringio'
require 'set'
require 'adamantium'
require 'ice_nine'
require 'abstract_type'
require 'descendants_tracker'
require 'securerandom'
require 'equalizer'
require 'digest/sha1'
require 'inflecto'
require 'parser'
require 'parser/current'
require 'unparser'
require 'ice_nine'
require 'diff/lcs'
require 'diff/lcs/hunk'
require 'rspec'
require 'anima'
require 'concord'
require 'rspec'

# Monkeypatch on parser with a list of allowed nodes.
# Will be pushed upstream once turning out to be correct.
module Parser
  module Meta
    NODE_TYPES =
      %w(
        true false nil int float str dstr str
        sym dsym xstr regopt regexp array splat
        array pair kwsplat hash irange erange self
        lvar ivar cvar gvar const defined? lvasgn
        ivasgn cvasgn gvasgn casgn mlhs masgn op_asgn
        op_asgn and_asgn ensure rescue arg_expr
        or_asgn and_asgn or_asgn back_ref nth_ref
        match_with_lvasgn match_current_line
        module class sclass def defs undef alias args
        cbase arg optarg restarg blockarg block_pass args def kwarg kwoptarg
        kwrestarg send super zsuper yield block send
        and not or if when case while until while_post
        until_post for break next redo return resbody
        kwbegin begin retry preexe postexe iflipflop eflipflop
        shadowarg
      ).map(&:to_sym).to_set.freeze
  end # Meta
end # Parser

# Library namespace
module Mutant
  # The empty string used within this namespace
  EMPTY_STRING = ''.freeze
end # Mutant

require 'mutant/version'
require 'mutant/cache'
require 'mutant/node_helpers'
require 'mutant/singleton_methods'
require 'mutant/constants'
require 'mutant/random'
require 'mutant/predicate'
require 'mutant/predicate/attribute'
require 'mutant/predicate/whitelist'
require 'mutant/predicate/blacklist'
require 'mutant/predicate/matcher'
require 'mutant/mutator'
require 'mutant/mutation'
require 'mutant/mutation/evil'
require 'mutant/mutation/neutral'
require 'mutant/mutator/registry'
require 'mutant/mutator/util'
require 'mutant/mutator/util/array'
require 'mutant/mutator/util/symbol'
require 'mutant/mutator/node'
require 'mutant/mutator/node/generic'
require 'mutant/mutator/node/literal'
require 'mutant/mutator/node/literal/boolean'
require 'mutant/mutator/node/literal/range'
require 'mutant/mutator/node/literal/symbol'
require 'mutant/mutator/node/literal/string'
require 'mutant/mutator/node/literal/fixnum'
require 'mutant/mutator/node/literal/float'
require 'mutant/mutator/node/literal/array'
require 'mutant/mutator/node/literal/hash'
require 'mutant/mutator/node/literal/regex'
require 'mutant/mutator/node/literal/nil'
require 'mutant/mutator/node/argument'
require 'mutant/mutator/node/arguments'
require 'mutant/mutator/node/blockarg'
require 'mutant/mutator/node/begin'
require 'mutant/mutator/node/binary'
require 'mutant/mutator/node/const'
require 'mutant/mutator/node/dstr'
require 'mutant/mutator/node/dsym'
require 'mutant/mutator/node/kwbegin'
require 'mutant/mutator/node/named_value/access'
require 'mutant/mutator/node/named_value/constant_assignment'
require 'mutant/mutator/node/named_value/variable_assignment'
require 'mutant/mutator/node/loop_control'
require 'mutant/mutator/node/noop'
require 'mutant/mutator/node/op_asgn'
require 'mutant/mutator/node/conditional_loop'
require 'mutant/mutator/node/yield'
require 'mutant/mutator/node/super'
require 'mutant/mutator/node/zsuper'
require 'mutant/mutator/node/restarg'
require 'mutant/mutator/node/send'
require 'mutant/mutator/node/send/binary'
require 'mutant/mutator/node/when'
require 'mutant/mutator/node/define'
require 'mutant/mutator/node/mlhs'
require 'mutant/mutator/node/nthref'
require 'mutant/mutator/node/masgn'
require 'mutant/mutator/node/return'
require 'mutant/mutator/node/block'
require 'mutant/mutator/node/if'
require 'mutant/mutator/node/case'
require 'mutant/mutator/node/splat'
require 'mutant/mutator/node/resbody'
require 'mutant/config'
require 'mutant/loader'
require 'mutant/context'
require 'mutant/context/scope'
require 'mutant/subject'
require 'mutant/subject/method'
require 'mutant/subject/method/instance'
require 'mutant/subject/method/singleton'
require 'mutant/matcher'
require 'mutant/matcher/chain'
require 'mutant/matcher/method'
require 'mutant/matcher/method/finder'
require 'mutant/matcher/method/singleton'
require 'mutant/matcher/method/instance'
require 'mutant/matcher/methods'
require 'mutant/matcher/namespace'
require 'mutant/matcher/scope'
require 'mutant/matcher/filter'
require 'mutant/killer'
require 'mutant/killer/static'
require 'mutant/killer/rspec'
require 'mutant/killer/forking'
require 'mutant/killer/forked'
require 'mutant/strategy'
require 'mutant/strategy/rspec'
require 'mutant/runner'
require 'mutant/runner/config'
require 'mutant/runner/subject'
require 'mutant/runner/mutation'
require 'mutant/cli'
require 'mutant/cli/classifier'
require 'mutant/cli/classifier/namespace'
require 'mutant/cli/classifier/method'
require 'mutant/cli/builder'
require 'mutant/color'
require 'mutant/differ'
require 'mutant/reporter'
require 'mutant/reporter/null'
require 'mutant/reporter/cli'
require 'mutant/reporter/cli/printer'
require 'mutant/reporter/cli/printer/config'
require 'mutant/reporter/cli/printer/subject'
require 'mutant/reporter/cli/printer/killer'
require 'mutant/reporter/cli/printer/mutation'
require 'mutant/zombifier'
