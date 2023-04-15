defmodule NonceGeekDAO.Character.LoginController do
  use Kalevala.Character.Controller

  require Logger

  alias Web3MUDEx.Characters
  alias Kalevala.Character
  alias NonceGeekDAO.Character.ChannelEvent
  alias NonceGeekDAO.Character.CharacterView
  alias NonceGeekDAO.Character.CommandController
  alias NonceGeekDAO.Character.LoginView
  alias NonceGeekDAO.Character.MoveEvent
  alias NonceGeekDAO.Character.MoveView
  alias NonceGeekDAO.Character.QuitView
  alias NonceGeekDAO.Character.TellEvent
  alias NonceGeekDAO.CharacterChannel
  alias NonceGeekDAO.Communication

  @impl true
  def init(conn) do
    conn
    |> put_session(:login_state, :username)
    |> render(LoginView, "welcome", %{})
    |> prompt(LoginView, "name", %{})
  end

  @impl true
  def recv_event(conn, event) do
    case event.topic do
      "Login.Character" ->
        process_character_token(conn, event.data["token"])

      _ ->
        conn
    end
  end

  @impl true
  def recv(conn, ""), do: conn

  def recv(conn, data) do
    case get_session(conn, :login_state) do
      :username ->
        process_username(conn, data)

      :password ->
        process_password(conn, data)

      :character ->
        process_character(conn, data)
    end
  end

  defp process_username(conn, data) do
    name = String.trim(data)

    case name do
      "" ->
        prompt(conn, LoginView, "name", %{})

      <<4>> ->
        conn
        |> prompt(QuitView, "goodbye", %{})
        |> halt()

      "quit" ->
        conn
        |> prompt(QuitView, "goodbye", %{})
        |> halt()

      name ->
        conn
        |> put_session(:login_state, :password)
        |> put_session(:username, name)
        |> send_option(:echo, true)
        |> prompt(LoginView, "password", %{})
    end
  end

  defp process_password(conn, _data) do
    name = get_session(conn, :username)

    Logger.info("Signing in \"#{name}\"")

    conn
    |> put_session(:login_state, :character)
    |> send_option(:echo, false)
    |> render(LoginView, "signed-in", %{})
    |> prompt(LoginView, "character-name", %{})
  end

  defp process_character(conn, character_name) do
    character =
      character_name
      |> String.trim()
      |> build_character()

    conn
    |> put_session(:login_state, :authenticated)
    |> put_character(character)
    |> render(CharacterView, "vitals", %{})
    |> move(:to, character.room_id, MoveView, "enter", %{})
    |> subscribe("rooms:#{character.room_id}", [], &MoveEvent.subscribe_error/2)
    |> register_and_subscribe_character_channel(character)
    |> subscribe("general", [], &ChannelEvent.subscribe_error/2)
    |> render(LoginView, "enter-world", %{})
    |> put_controller(CommandController)
    |> event("room/look", %{})
    |> event("inventory/list", %{})
  end

  defp process_character_token(conn, token) do
    case Phoenix.Token.verify(Web.Endpoint, "character id", token, max_age: 3600) do
      {:ok, character_id} ->
        {:ok, character} = Characters.get(character_id)

        process_character(conn, character.name)
    end
  end

  defp build_character(name) do
    starting_room_id =
      NonceGeekDAO.Config.get([:player, :starting_room_id])
      |> NonceGeekDAO.World.dereference()

    # generate an Sui Acct.
    {
      :ok,
      %{
        sui_address_hex: sui_addr,
        priv_key_base64: priv,
        }
    } = {:ok, %Web3MoveEx.Sui.Account{
      sui_address: <<173, 247, 138, 113, 25, 16, 185, 209, 222, 3, 2, 38, 31, 18,
        48, 156, 136, 2, 245, 243, 0, 205, 170, 16, 200, 119, 17, 120, 234, 150,
        208, 145>>,
      sui_address_hex: "0xadf78a711910b9d1de0302261f12309c8802f5f300cdaa10c8771178ea96d091",
      priv_key: <<0, 11, 166, 31, 134, 41, 92, 19, 157, 130, 92, 13, 61, 169, 69,
        25, 184, 250, 110, 217, 83, 192, 231, 128, 112, 2, 108, 115, 39, 229, 224,
        14, 7>>,
      priv_key_base64: "AAumH4YpXBOdglwNPalFGbj6btlTwOeAcAJscyfl4A4H",
      key_schema: "ed25519",
      phrase: "city record reject glow similar misery finger tongue wage diesel high prevent end gadget pill tiny shine muffin prefer coffee custom shell quantum office"
    }}

    %Character{
      id: Character.generate_id(),
      pid: self(),
      room_id: starting_room_id,
      name: name,
      status: "#{name} is here.",
      description: "#{name} is a web3 buidler.",
      inventory: [
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:airdropper",
          created_at: DateTime.utc_now(),
          meta: %NonceGeekDAO.World.Item.Meta{}
        },
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:crowdfund",
          created_at: DateTime.utc_now(),
          meta: %NonceGeekDAO.World.Item.Meta{}
        },
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:genreadme",
          created_at: DateTime.utc_now(),
          meta: %NonceGeekDAO.World.Item.Meta{}
        },
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:bountychecker",
          created_at: DateTime.utc_now(),
          meta: %NonceGeekDAO.World.Item.Meta{}
        }
      ],
      meta: %NonceGeekDAO.Character.PlayerMeta{
        vitals: %NonceGeekDAO.Character.Vitals{
          sui_addr: sui_addr,
          priv: priv,
          health_points: 25,
          max_health_points: 25,
          skill_points: 17,
          max_skill_points: 17,
          endurance_points: 30,
          max_endurance_points: 30
        }
      }
    }
  end

  defp register_and_subscribe_character_channel(conn, character) do
    options = [character_id: character.id]
    :ok = Communication.register("characters:#{character.id}", CharacterChannel, options)

    options = [character: character]
    subscribe(conn, "characters:#{character.id}", options, &TellEvent.subscribe_error/2)
  end
end
