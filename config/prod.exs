use Mix.Config

config :phoenix_poker, PhoenixPoker.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "morning-river-32535.herokuapp.com", port: 443],
  # debug_errors: true,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :phoenix_poker, PhoenixPoker.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
