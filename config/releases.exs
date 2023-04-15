import Config

config :web3_mud_ex, Web3MUDEx.Repo, ssl: System.get_env("DATABASE_SSL") == "true"

config :web3_mud_ex, Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :web3_mud_ex, Web3MUDEx.Mailer, adapter: Bamboo.LocalAdapter

config :logger, level: :info

config :phoenix, :logger, false

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers
