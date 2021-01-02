# frozen_string_literal: true

Mutant::Meta::Example.add :regexp_named_group do
  source '/(?<foo>)/'

  singleton_mutations
  regexp_mutations
end

Mutant::Meta::Example.add :regexp_named_group do
  source '/(?<foo>\w)/'

  singleton_mutations
  regexp_mutations

  mutation '/(?:\w)/'
  mutation '/(?<foo>\W)/'
end
