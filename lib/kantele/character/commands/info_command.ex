defmodule NonceGeekDAO.Character.InfoCommand do
  use Kalevala.Character.Command

  alias NonceGeekDAO.Character.InfoView

  def run(conn, _params) do
    render(conn, InfoView, "display")
  end
end
