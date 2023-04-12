defmodule Web3MudExExample.Character.Emote do
  @moduledoc """
  A static emote that players can use via a command
  """

  defstruct [:command, :text]
end

defmodule Web3MudExExample.Character.Emotes do
  @moduledoc false

  use Kalevala.Cache

  alias Web3MudExExample.Character.Emote

  @impl true
  def initialize(state) do
    File.read!("data/emotes.ucl")
    |> Elias.parse()
    |> Map.get(:emotes)
    |> Enum.map(fn {_key, emote} ->
      %Emote{
        command: emote.command,
        text: emote.text
      }
    end)
    |> Enum.map(fn emote ->
      Kalevala.Cache._put(state, emote.command, emote)
    end)
  end
end
