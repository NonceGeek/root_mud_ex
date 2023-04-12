defmodule Web3MudExExample.Character.MapCommand do
  use Kalevala.Character.Command

  def run(conn, _params) do
    event(conn, "zone-map/look")
  end
end
