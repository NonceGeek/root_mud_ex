defmodule NonceGeekDAO.Character.InventoryCommand do
  use Kalevala.Character.Command

  alias NonceGeekDAO.Character.InventoryView
  alias NonceGeekDAO.World.Items

  def run(conn, _params) do
    item_instances =
      Enum.map(conn.character.inventory, fn item_instance ->
        %{item_instance | item: Items.get!(item_instance.item_id)}
      end)

    conn
    |> assign(:item_instances, item_instances)
    |> render(InventoryView, "list")
  end
end
