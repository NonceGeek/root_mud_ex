defmodule Kantele.Character.FightEvent do
  use Kalevala.Character.Event

  require Logger

  alias Kantele.Character.CommandView
  alias Kantele.Character.FightView

  alias ExVenture.Fight

  def interested?(event) do
    match?("characters:" <> _, event.data.channel_name)
  end

  @doc """
    commands -> fight_command -> events -> fightevent -> room -> fightevent -> here.
  """
  def broadcast(conn = %{character: character_1}, %{data: %{character: character_2}}) when character_2 != nil do
    IO.puts inspect character_1
    IO.puts inspect character_2
    Logger.info("--- fight ---")

    # fight LOGIC.
    %{character_1: character_1, character_2: character_2} = 
        Fight.fight(character_1, character_2)

    conn
    |> put_meta(:reply_to, character_2.name)
    |> put_character(character_1)
    # |> put_character(character_2)
    |> assign(:character, character_2)
    |> assign(:text, "Aha")
    |> render(FightView, "echo")
    |> prompt(CommandView, "prompt", %{})
    |> publish_message("characters:#{character_2.id}", "AHA", [], &publish_error/2)
  end

  def broadcast(conn, event) do
    conn
    |> assign(:name, event.data.name)
    |> render(FightView, "character-not-found")
    |> prompt(CommandView, "prompt", %{})
  end

  def echo(conn, event) do
    conn
    |> assign(:character, event.data.character)
    |> assign(:id, event.data.id)
    |> assign(:text, event.data.text)
    |> render(FightView, "listen")
    |> prompt(CommandView, "prompt", %{})
  end

  def subscribe_error(conn, error) do
    Logger.error("Tried to subscribe to the new channel and failed - #{inspect(error)}")

    conn
  end

  def publish_error(conn, error) do
    Logger.error("Tried to publish to a channel and failed - #{inspect(error)}")

    conn
  end
end
