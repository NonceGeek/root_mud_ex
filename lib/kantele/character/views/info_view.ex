defmodule NonceGeekDAO.Character.InfoView do
  use Kalevala.Character.View

  alias Kalevala.Character.Conn.EventText

  def render("display", %{character: character}) do
    %EventText{
      topic: "Character.Info",
      data: character,
      text: render("_display", %{character: character})
    }
  end

  def render("_display", %{character: character}) do
    vitals = character.meta.vitals

    ~i"""
    {table}
      {row}
        {cell}Winzard of SUI{/cell}
      {/row}
      {row}
        {cell}{sui_addr}#{vitals.sui_addr}{/sui_addr}{/cell}
      {/row}
      {row}
        {cell}HP{/cell}
        {cell}{hp}#{vitals.health_points}/#{vitals.max_health_points}{/hp}{/cell}
      {/row}
      {row}
        {cell}SP{/cell}
        {cell}{sp}#{vitals.skill_points}/#{vitals.max_skill_points}{/sp}{/cell}
      {/row}
      {row}
        {cell}EP{/cell}
        {cell}{ep}#{vitals.endurance_points}/#{vitals.max_endurance_points}{/ep}{/cell}
      {/row}
    {/table}
    """
  end
end
