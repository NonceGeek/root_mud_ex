defmodule Web3MudExExample.Character.WhoCommand do
  use Kalevala.Character.Command

  alias Web3MudExExample.Character.WhoView
  alias Web3MudExExample.Character.Presence

  def run(conn, _params) do
    conn
    |> assign(:characters, Presence.characters())
    |> render(WhoView, "list")
  end
end
