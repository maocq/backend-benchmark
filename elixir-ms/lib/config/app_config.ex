defmodule ElixirMs.Config.AppConfig do
  @moduledoc false

  defstruct [
    :timezone,
    :http_port,
    :enable_server,
    :secret_name,
    :region,
    :token_exp,
    :cache_expiration,
    :external_service_ip,
    :version,
  ]

  def load_config do
    %__MODULE__{
      timezone: load(:timezone),
      http_port: load(:http_port),
      enable_server: load(:enable_server),
      secret_name: load(:secret_name),
      region: load(:region),
      token_exp: load(:token_exp),
      cache_expiration: load(:cache_expiration),
      external_service_ip: load(:external_service_ip),
      version: load(:version)
    }
  end

  defp load(property_name), do: Application.fetch_env!(:elixir_ms, property_name)
end
