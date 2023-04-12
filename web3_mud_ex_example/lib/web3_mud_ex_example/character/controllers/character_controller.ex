defmodule Web3MudExExample.Character.CharacterController do
  @moduledoc """
  Select one of your characters
  """

  use Kalevala.Character.Controller

  require Logger

  alias Kalevala.Character
  alias Web3MudExExample.Character.ChannelEvent
  alias Web3MudExExample.Character.CharacterView
  alias Web3MudExExample.Character.CommandController
  alias Web3MudExExample.Character.MoveEvent
  alias Web3MudExExample.Character.MoveView
  alias Web3MudExExample.Character.TellEvent
  alias Web3MudExExample.CharacterChannel
  alias Web3MudExExample.Communication

  @impl true
  def init(conn) do
    prompt(conn, CharacterView, "character-name")
  end

  @impl true
  def recv_event(conn, event) do
    case event.topic do
      "Login.Character" ->
        process_character(conn, event.data["character"])

      _ ->
        conn
    end
  end

  @impl true
  def recv(conn, ""), do: conn

  def recv(conn, data) do
    data = String.trim(data)

    process_character(conn, data)
  end

  defp process_character(conn, character_name) do
    character = build_character(character_name)

    conn
    |> put_session(:login_state, :authenticated)
    |> put_character(character)
    |> render(CharacterView, "vitals")
    |> move(:to, character.room_id, MoveView, "enter", %{})
    |> subscribe("rooms:#{character.room_id}", [], &MoveEvent.subscribe_error/2)
    |> register_and_subscribe_character_channel(character)
    |> subscribe("general", [], &ChannelEvent.subscribe_error/2)
    |> render(CharacterView, "enter-world")
    |> put_controller(CommandController)
    |> event("room/look", %{})
    |> event("inventory/list", %{})
  end

  defp build_character(name) do
    starting_room_id =
      Web3MudExExample.Config.get([:player, :starting_room_id])
      |> Web3MudExExample.World.dereference()

      # generate an Sui Acct.
      {
        :ok,
        %{
          sui_address_hex: sui_addr,
          priv_key_base64: priv,
          }
      } = Web3MoveEx.Sui.gen_acct()

    IO.puts "dddddd"
    %Character{
      id: Character.generate_id(),
      pid: self(),
      room_id: starting_room_id,
      name: name,
      status: "#{name} is here.",
      description: "#{name} is a person.",
      inventory: [
        %Kalevala.World.Item.Instance{
          id: Kalevala.World.Item.Instance.generate_id(),
          item_id: "global:potion",
          created_at: DateTime.utc_now(),
          meta: %Web3MudExExample.World.Item.Meta{}
        }
      ],
      meta: %Web3MudExExample.Character.PlayerMeta{
        vitals: %Web3MudExExample.Character.Vitals{
          health_points: 25,
          max_health_points: 25,
          skill_points: 17,
          max_skill_points: 17,
          endurance_points: 30,
          max_endurance_points: 30,
          sui_addr: sui_addr,
          priv: priv
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
