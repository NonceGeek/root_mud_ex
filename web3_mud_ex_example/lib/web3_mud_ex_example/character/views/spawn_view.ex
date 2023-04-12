defmodule Web3MudExExample.Character.SpawnView do
  use Kalevala.Character.View

  alias Web3MudExExample.Character.CharacterView

  def render("spawn", %{character: character}) do
    ~i(#{CharacterView.render("name", %{character: character})} spawned.)
  end
end
