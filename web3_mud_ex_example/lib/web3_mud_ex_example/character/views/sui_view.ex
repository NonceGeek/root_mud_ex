defmodule Web3MudExExample.Character.SuiView do
    use Kalevala.Character.View

    alias Kalevala.Character.Conn.EventText

    def render("getobjsbyowner", %{addr: addr}) do
      %EventText{
        topic: "Sui.Interactor",
        data: addr,
        text: render("_getobjsbyowner", addr)
      }
    end
    def render("getobj", %{obj_id: obj_id}) do
      %EventText{
        topic: "Sui.Interactor",
        data: obj_id,
        text: render("_getobj", obj_id)
      }
    end

    def render("_getobj",  obj_id) do
      # TODO: get_obj from chain.
      {:ok, client} =
        Web3MoveEx.Sui.RPC.connect()

      {:ok, obj} =
        Web3MoveEx.Sui.get_object(client, obj_id)
      %{data: %{content: %{fields: fields, type: type}, owner: owner}} = obj
      ~i"""
        Fields: #{inspect(fields)}
        Types: #{inspect(type)}
        Owner: #{inspect(owner)}
      """
    end

    def render("_getobjsbyowner",  addr) do
      # TODO: get_obj from chain.
      {:ok, client} =
        Web3MoveEx.Sui.RPC.connect()
      {
        :ok,
        %{
          data: obj_lists
        }
      } = Web3MoveEx.Sui.get_objects_by_owner(client, addr)
      obj_lists_handled =
        Enum.map(obj_lists, &(&1.data.objectId))
      ~i"""
        Objects: #{inspect(obj_lists_handled)}
      """
    end
  end
