defmodule Web.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :web3_mud_ex

  alias Web3MUDEx.Application.KalevalaSupervisor
  alias Web3MUDEx.Config

  socket "/socket", Web.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :web3_mud_ex,
    gzip: false,
    only_matching: ["apple", "favicon", "android"],
    only: ~w(css fonts images js favicon.ico robots.txt manifest.json)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Logster.Plugs.Logger

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_web3_mud_ex_key",
    signing_salt: "76sn4b3J"

  if Mix.env() == :dev do
    plug(Plug.Static, at: "/uploads", from: "uploads/files")
  end

  plug Web.Router

  def init(_type, config) do
    vapor_config = Config.endpoint()

    websocket_config = %{
      handler: [
        output_processors: [
          Kalevala.Output.Tags,
          NonceGeekDAO.Output.AdminTags,
          NonceGeekDAO.Output.SemanticColors,
          NonceGeekDAO.Output.Tooltips,
          NonceGeekDAO.Output.Commands,
          Kalevala.Output.Tables,
          Kalevala.Output.Websocket
        ]
      ],
      foreman: KalevalaSupervisor.foreman_options()
    }

    config =
      Keyword.merge(config,
        http: [
          port: vapor_config.http_port,
          dispatch: [
            {:_,
             [
               {"/socket", Kalevala.Websocket.Handler, websocket_config},
               {:_, Phoenix.Endpoint.Cowboy2Handler, {Web.Endpoint, []}}
             ]}
          ]
        ],
        secret_key_base: vapor_config.secret_key_base,
        url: [
          host: vapor_config.url_host,
          port: vapor_config.url_port,
          scheme: vapor_config.url_scheme
        ]
      )

    {:ok, config}
  end
end
