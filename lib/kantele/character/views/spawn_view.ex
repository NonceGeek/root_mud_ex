defmodule NonceGeekDAO.Character.SpawnView do
  use Kalevala.Character.View

  alias NonceGeekDAO.Character.CharacterView

  def render("spawn", %{character: character}) do
    ~i(#{CharacterView.render("name", %{character: character})} spawned.)
  end
end
