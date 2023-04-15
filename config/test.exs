use Mix.Config

#
# If you're looking to update variables, you probably want to:
# - Edit `.env.test`
# - Add to `Web3MUDEx.Config` for loading through Vapor
#

# Configure your database
config :web3_mud_ex, Web3MUDEx.Repo, pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web3_mud_ex, Web.Endpoint,
  http: [port: 4002],
  server: false

config :web3_mud_ex, Web3MUDEx.Mailer, adapter: Bamboo.TestAdapter

config :web3_mud_ex, :listener, start: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4

config :stein_storage, backend: :test
