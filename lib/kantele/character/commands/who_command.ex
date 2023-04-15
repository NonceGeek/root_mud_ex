defmodule NonceGeekDAO.Character.WhoCommand do
  use Kalevala.Character.Command

  alias NonceGeekDAO.Character.WhoView
  alias NonceGeekDAO.Character.Presence

  def run(conn, _params) do
    conn
    |> assign(:characters, Presence.characters())
    |> render(WhoView, "list")
  end
end
