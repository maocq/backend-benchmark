defmodule ElixirMs.Adapters.HelloHttp do
  alias ElixirMs.Adapters.Http.HttpClient
  alias ElixirMs.DrivenAdapters.Secrets.SecretManagerAdapter

  @behaviour ElixirMs.Model.Behaviour.HelloRepository

  def hello(latency) do
    %{ external_service_ip: external_service_ip } = SecretManagerAdapter.get_secret()
    url = "http://#{external_service_ip}:8080/#{latency}"

    case Finch.build(:get, url) |> Finch.request(HttpFinch) do
      {:ok, %Finch.Response{body: body}} -> {:ok, body}
      error -> error
    end
  end

  defp hello_mint(latency) do
    %{ external_service_ip: external_service_ip } = SecretManagerAdapter.get_secret()

    case HttpClient.request(:http, external_service_ip, 8080, "GET", "/#{latency}") do
      {:ok, response} -> {:ok, List.first(response.data)}
      error -> error
    end
  end
end
