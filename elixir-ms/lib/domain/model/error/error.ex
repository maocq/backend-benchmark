defmodule ElixirMs.Model.Error do
  @moduledoc false

  defstruct [
    :error,
    :message,
    fields: []
  ]

  @type t() :: %__MODULE__{error: atom, message: String.t(), fields: list(String.t())}
end
