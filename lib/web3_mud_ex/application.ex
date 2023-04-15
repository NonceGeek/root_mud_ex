defmodule Web3MUDEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Web3MUDEx.PubSub},
      Web3MUDEx.Config.Cache,
      Web3MUDEx.Repo,
      Web3MUDEx.Application.KalevalaSupervisor,
      Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Web3MUDEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Web.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Web3MUDEx.Application.KalevalaSupervisor do
  @moduledoc false

  use Supervisor

  def foreman_options() do
    [
      supervisor_name: NonceGeekDAO.Character.Foreman.Supervisor,
      communication_module: NonceGeekDAO.Communication,
      initial_controller: NonceGeekDAO.Character.LoginController,
      presence_module: NonceGeekDAO.Character.Presence,
      quit_view: {NonceGeekDAO.Character.QuitView, "disconnected"}
    ]
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_args) do
    telnet_config = [
      telnet: [
        port: 4646
      ],
      protocol: [
        output_processors: [
          Kalevala.Output.Tags,
          NonceGeekDAO.Output.AdminTags,
          NonceGeekDAO.Output.SemanticColors,
          Kalevala.Output.Tables,
          Kalevala.Output.TagColors,
          Kalevala.Output.StripTags
        ]
      ],
      foreman: foreman_options()
    ]

    children = [
      {NonceGeekDAO.Config, [name: NonceGeekDAO.Config]},
      {NonceGeekDAO.Communication, []},
      {Kalevala.Help, [name: NonceGeekDAO.Help]},
      {NonceGeekDAO.World, []},
      {NonceGeekDAO.Character.Presence, []},
      {NonceGeekDAO.Character.Emotes, [name: NonceGeekDAO.Character.Emotes]},
      {Kalevala.Character.Foreman.Supervisor, [name: NonceGeekDAO.Character.Foreman.Supervisor]},
      telnet_listener(telnet_config)
    ]

    children =
      Enum.reject(children, fn child ->
        is_nil(child)
      end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def telnet_listener(telnet_config) do
    config = Application.get_env(:web3_mud_ex, :listener, [])

    case Keyword.get(config, :start, true) do
      true ->
        {Kalevala.Telnet.Listener, telnet_config}

      false ->
        nil
    end
  end
end
