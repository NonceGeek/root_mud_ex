defmodule Web3MudExExample.Character.InfoCommand do
  use Kalevala.Character.Command

  alias Web3MudExExample.Character.InfoView

  def run(conn, _params) do
    render(conn, InfoView, "display")
  end
end
