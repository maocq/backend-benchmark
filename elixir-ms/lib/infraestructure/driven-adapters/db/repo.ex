defmodule ElixirMs.Repo do
  use Ecto.Repo,
    otp_app: :elixir_ms,
    adapter: Ecto.Adapters.Postgres
end
