defmodule NonceGeekDAO.Character.SuiView do
    use Kalevala.Character.View

    alias Kalevala.Character.Conn.EventText

    def render("getobjsbyowner", %{addr: addr}) do
      %EventText{
        topic: "Character.Info",
        data: addr,
        text: render("_getobjsbyowner", addr)
      }
    end

    def render("getobj", %{obj_id: obj_id}) do
      %EventText{
        topic: "Character.Info",
        data: obj_id,
        text: render("_getobj", obj_id)
      }
    end

    def render("getobjtest", %{obj_id: obj_id}) do
      %EventText{
        topic: "Character.Info",
        data: obj_id,
        text: ~i"""
          Hello World!
        """
      }
    end

    def render("getcontributors", _) do
      IO.puts "ddddd"
      %EventText{
        topic: "Character.Info",
        data: "web3_move_ex",
        text: ~i"""
        {table}
          {row}
            {cell}Contributors of web3_move_ex{/cell}
          {/row}
          {row}
            {cell}{username}leeduckgo{/username}{/cell}
          {/row}
          {row}
            {cell}0xadf78a711910b9d1de0302261f12309c8802f5f300cdaa10c8771178ea96d091{/cell}
          {/row}
          {row}
          {cell}{username}zven21{/username}{/cell}
          {/row}
          {row}
          {cell}0x07d3af2729d540b58c80a808c337fc89938114d26ecd0e9c786148b78229c2b5{/cell}
          {/row}
        {/table}
        """
      }
    end

    def render("_getobj",  obj_id) do

      {:ok, client} =
        Web3MoveEx.Sui.RPC.connect()

      {:ok, obj} =
        Web3MoveEx.Sui.get_object(client, obj_id)
      %{data: %{content: %{fields: fields, type: type}, owner: owner}} = obj
      IO.puts inspect obj
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
