defmodule Web3MudExExample.Character.DelayedEvent do
  use Kalevala.Character.Event

  alias Web3MudExExample.Character.CommandController
  alias Web3MudExExample.Character.DelayedView

  def run(conn, %{data: %{"command" => command}}) do
    conn
    |> render(DelayedView, "display", %{command: command})
    |> CommandController.recv(command)
  end
end
