defmodule NonceGeekDAO.Character.QuitCommand do
  use Kalevala.Character.Command

  alias NonceGeekDAO.Character.QuitView

  def run(conn, _params) do
    conn
    |> assign(:prompt, false)
    |> render(QuitView, "goodbye")
    |> halt()
  end
end
