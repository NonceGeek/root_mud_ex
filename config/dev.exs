use Mix.Config

#
# If you're looking to update variables, you probably want to:
# - Edit `.env`
# - Add to `Web3MUDEx.Config` for loading through Vapor
#

# Configure your database
config :web3_mud_ex, Web3MUDEx.Repo, show_sensitive_data_on_connection_error: true

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :web3_mud_ex, Web.Endpoint,
  server: true,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "./node_modules/.bin/yarn",
      "run",
      "build:js:watch",
      cd: Path.expand("../assets", __DIR__)
    ],
    node: [
      "./node_modules/.bin/yarn",
      "run",
      "build:css:watch",
      cd: Path.expand("../assets", __DIR__)
    ],
    node: [
      "./node_modules/.bin/yarn",
      "run",
      "build:static:watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :web3_mud_ex, Web.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/web/{live,views}/.*(ex)$",
      ~r"lib/web/templates/.*(eex)$"
    ]
  ]

config :web3_mud_ex, Web3MUDEx.Mailer, adapter: Bamboo.LocalAdapter

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix, :logger, false

config :stein_storage,
  backend: :file,
  file_backend_folder: "uploads/"
