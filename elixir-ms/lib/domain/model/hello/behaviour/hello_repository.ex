defmodule ElixirMs.Model.Behaviour.HelloRepository do

  @callback hello(term()) :: {:ok, String.t()} | {:error, term()}
end
