defmodule Web3MudExExample.Character.QuitCommand do
  use Kalevala.Character.Command

  alias Web3MudExExample.Character.QuitView

  def run(conn, _params) do
    conn
    |> assign(:prompt, false)
    |> render(QuitView, "goodbye")
    |> halt()
  end
end
