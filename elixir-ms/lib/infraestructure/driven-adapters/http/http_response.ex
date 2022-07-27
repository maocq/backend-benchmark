defmodule ElixirMs.Adapters.Http.HttpResponse do
  @moduledoc """
    HTTP client
  """

  defstruct [
    :status,
    :status_http,
    :headers,
    data: []
  ]

  @type t() :: %__MODULE__{status: atom(), status_http: integer(),
  headers: list(tuple()), data: any()}

end
