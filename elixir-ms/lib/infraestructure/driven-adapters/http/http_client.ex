defmodule ElixirMs.Adapters.Http.HttpClient do
  @moduledoc """
    HTTP client
  """

  alias ElixirMs.Adapters.Http.HttpResponse

  require Logger

  @spec request(atom(), String.t(), integer(), String.t(), String.t(), String.t(), list()) :: {:ok, HttpResponse.t()} | {:error, :http_error}
  def request(scheme, address, port, method, path, body \\ "", headers \\ []) do
    with {:ok, conn} <- Mint.HTTP.connect(scheme, address, port),
         {:ok, conn, req} <- Mint.HTTP.request(conn, method, path, headers, body),
         {:ok, conn, %{status_http: _http_status} = response} <- handle_response(conn, req) do

      Mint.HTTP.close(conn)
      {:ok, response}
    else
      {:error, conn, error, response} ->
        Mint.HTTP.close(conn)
        Logger.error("HTTP error #{inspect(error)} #{inspect(response)}")
        {:error, :http_error}
      error ->
        Logger.error("HTTP error #{inspect(error)}")
        {:error, :http_error}
    end
  end

  defp handle_response(conn, request_ref, http_response \\ %HttpResponse{status: :incomplete}) do
    case recibe_message(conn, request_ref, http_response) do
      {:ok, conn, %{status: :incomplete} = http_res} -> handle_response(conn, request_ref, http_res)
      complete -> complete
    end
  end

  defp recibe_message(conn, request_ref, http_response) do
    receive do
      message ->
        with {:ok, conn, response} <- Mint.HTTP.stream(conn, message) do
          http_res = Enum.reduce(response, http_response, fn res, http_res -> reduce_response(res, http_res, request_ref) end)
          {:ok, conn, http_res}
        end
    end
  end

  defp reduce_response(res, http_res, request_ref) do
    case res do
      {:status, ^request_ref, status_code} ->  %{http_res | status_http: status_code}
      {:headers, ^request_ref, headers} -> %{http_res | headers: headers}
      {:data, ^request_ref, data} -> %{http_res | data: [data | http_res.data]}
      {:done, ^request_ref} -> %{http_res | data: Enum.reverse(http_res.data), status: :complete}
    end
  end
end
