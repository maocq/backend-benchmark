import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :elixir_ms, timezone: "America/Bogota"

config :elixir_ms,
  http_port: 8080,
  enable_server: true,
  secret_name: "fua-dev-secret-CNX",
  region: "us-east-1",
  token_exp: 600,
  cache_expiration: 86400,
  rsa_private_key: "",
  kms_rsa_key_id: "",
  version: "1.2.3"

config :logger,
  level: :error

config :elixir_ms, ElixirMs.Repo,
  database: "compose-postgres",
  username: "compose-postgres",
  password: "compose-postgres",
  hostname: System.get_env("DATABASE_IP") || "db",
  pool_size: 10,
  queue_target: 5000,
  timeout: :timer.minutes(1)

config :elixir_ms, ecto_repos: [ElixirMs.Repo]

config :elixir_ms,
  external_service_ip: System.get_env("EXTERNAL_SERVICE_IP") || "node-latency"

config :elixir_ms,
  account_repository: ElixirMs.DrivenAdapters.Db.Repository.AccountDataRepository,
  hello_repository: ElixirMs.Adapters.HelloHttp
