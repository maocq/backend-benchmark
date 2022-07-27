defmodule ElixirMs.Model.Behaviour.AccountRepository do

  @callback find_by_id(number()) :: term
  @callback find_one() :: term
  @callback find_test() :: term
  @callback find_all() :: term
  @callback update(term) :: term
end
