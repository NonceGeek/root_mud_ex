defmodule NonceGeekDAO.Character.DelayedEvent do
  use Kalevala.Character.Event

  alias NonceGeekDAO.Character.CommandController
  alias NonceGeekDAO.Character.DelayedView

  def run(conn, %{data: %{"command" => command}}) do
    conn
    |> render(DelayedView, "display", %{command: command})
    |> CommandController.recv(command)
  end
end
