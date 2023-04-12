defmodule Web3MudExExample.Character.InventoryEvent do
  use Kalevala.Character.Event

  alias Web3MudExExample.Character.InventoryView
  alias Web3MudExExample.World.Items

  def list(conn, _params) do
    item_instances =
      Enum.map(conn.character.inventory, fn item_instance ->
        %{item_instance | item: Items.get!(item_instance.item_id)}
      end)

    conn
    |> assign(:item_instances, item_instances)
    |> render(InventoryView, "list.event")
  end
end
