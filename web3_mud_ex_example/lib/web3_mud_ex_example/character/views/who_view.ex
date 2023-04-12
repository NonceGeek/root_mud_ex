defmodule Web3MudExExample.Character.WhoView do
  use Kalevala.Character.View

  alias Web3MudExExample.Character.CharacterView

  def render("list", %{characters: characters}) do
    ~E"""
    Other players online:
    <%= render("_characters", %{characters: characters}) %>
    """
  end

  def render("_characters", %{characters: characters}) do
    characters
    |> Enum.map(&render("_character", %{character: &1}))
    |> View.join("\n")
  end

  def render("_character", %{character: character}) do
    ~i(- #{CharacterView.render("name", %{character: character})})
  end
end
