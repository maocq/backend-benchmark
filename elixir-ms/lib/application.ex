defmodule ElixirMs.Application do
  @moduledoc """
  Documentation for `MsCredentials`.
  """
  alias ElixirMs.Config.{AppConfig, ConfigHolder}
  alias ElixirMs.DrivenAdapters.Secrets.SecretManagerAdapter
  alias ElixirMs.EntryPoint.Rest.ElixirMsController
  alias ElixirMs.Helpers.CustomTelemetry


  use Application
  require Logger

  def start(_type, _args) do
    config = AppConfig.load_config()
    in_test? = Application.fetch_env(:elixir_ms, :in_test)
    children = with_plug_server(config) ++ application_children(in_test?)

    CustomTelemetry.custom_telemetry_events()

    opts = [strategy: :one_for_one, name: Fua.Supervisor]
    Supervisor.start_link(children, opts)

  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}")

    [
      {
        Plug.Cowboy,
        scheme: :http,
        plug: ElixirMsController,
        options: [
          port: port
        ]
      }
    ]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def application_children({:ok, true} = _test_env),
    do: [
      {ConfigHolder, AppConfig.load_config()}
    ]

  def application_children(_other_env),
    do: [
      {ConfigHolder, AppConfig.load_config()},
      {SecretManagerAdapter, []},
      {ElixirMs.Repo, []},
      {Finch, name: HttpFinch, pools: %{:default => [size: 100]}}
    ]
end
