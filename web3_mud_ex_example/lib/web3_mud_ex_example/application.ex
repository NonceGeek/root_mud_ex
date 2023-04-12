defmodule Web3MudExExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    foreman_options = [
      supervisor_name: Web3MudExExample.Character.Foreman.Supervisor,
      communication_module: Web3MudExExample.Communication,
      initial_controller: Web3MudExExample.Character.LoginController,
      presence_module: Web3MudExExample.Character.Presence,
      quit_view: {Web3MudExExample.Character.QuitView, "disconnected"}
    ]

    telnet_config = [
      telnet: [
        port: 4444
      ],
      tls: [
        port: 4443,
        keyfile: Path.join(:code.priv_dir(:web3_mud_ex_example), "certs/key.pem"),
        certfile: Path.join(:code.priv_dir(:web3_mud_ex_example), "certs/cert.pem")
      ],
      protocol: [
        output_processors: [
          Kalevala.Output.Tags,
          Web3MudExExample.Output.AdminTags,
          Web3MudExExample.Output.SemanticColors,
          Kalevala.Output.Tables,
          Kalevala.Output.TagColors,
          Kalevala.Output.StripTags
        ]
      ],
      foreman: foreman_options
    ]

    websocket_config = [
      port: 4500,
      dispatch_matches: [
        {:_, Plug.Cowboy.Handler, {Web3MudExExample.Websocket.Endpoint, []}}
      ],
      handler: [
        output_processors: [
          Kalevala.Output.Tags,
          Web3MudExExample.Output.AdminTags,
          Web3MudExExample.Output.SemanticColors,
          Web3MudExExample.Output.Tooltips,
          Web3MudExExample.Output.Commands,
          Kalevala.Output.Tables,
          Kalevala.Output.Websocket
        ]
      ],
      foreman: foreman_options
    ]

    children = [
      {Web3MudExExample.Config, [name: Web3MudExExample.Config]},
      {Web3MudExExample.Communication, []},
      {Kalevala.Help, [name: Web3MudExExample.Help]},
      {Web3MudExExample.World, []},
      {Web3MudExExample.Character.Presence, []},
      {Web3MudExExample.Character.Emotes, [name: Web3MudExExample.Character.Emotes]},
      {Kalevala.Character.Foreman.Supervisor, [name: Web3MudExExample.Character.Foreman.Supervisor]},
      telnet_listener(telnet_config),
      websocket_listener(websocket_config),
      {Web3MudExExample.Telemetry, []}
    ]

    children =
      Enum.reject(children, fn child ->
        is_nil(child)
      end)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Web3MudExExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def telnet_listener(telnet_config) do
    config = Application.get_env(:web3_mud_ex_example, :listener, [])

    case Keyword.get(config, :start, true) do
      true ->
        {Kalevala.Telnet.Listener, telnet_config}

      false ->
        nil
    end
  end

  def websocket_listener(websocket_config) do
    config = Application.get_env(:web3_mud_ex_example, :listener, [])

    case Keyword.get(config, :start, true) do
      true ->
        {Kalevala.Websocket.Listener, websocket_config}

      false ->
        nil
    end
  end
end
