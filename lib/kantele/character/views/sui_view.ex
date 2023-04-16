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

    def render("checkroom", %{room_name: "web3_move_ex"}) do
      {:ok, client} =
        Web3MoveEx.Sui.RPC.connect()

      {:ok, %{data: data}} =
        Web3MoveEx.Sui.get_object(
          client,
          "0xf28b5a262a34062ea7d3d114bff824c603afc1850b8b3ebde1f940c55c4a8578"
        )
      data_handled = data_to_str(data.content.fields)
      %EventText{
        topic: "Character.Info",
        data: "check_room",
        text: ~i"""
        #{data_handled}
        """
      }
    end

    def data_to_str(data) do
      Enum.reduce(data, "", fn {k, v}, acc ->
        acc
        |> Kernel.<>("#{k}: #{inspect(v)}\n\n")
      end)
    end

    def render("getcontributors", _) do
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

    def render("airdrop",
      %{
        coin_num: coin_num,
        character: character}) do
      {:ok, client} =
        Web3MoveEx.Sui.RPC.connect()
      priv = character.meta.vitals.priv
      acct = Web3MoveEx.Sui.Account.from(priv)
      IO.puts inspect priv
      IO.puts inspect acct
      # call func_on_chain.

      {:ok, %{data: data}} =
        Web3MoveEx.Sui.get_all_coins(
          client,
          acct.sui_address_hex)
      obj_id = data |> Enum.fetch!(0) |> Map.get(:coinObjectId)

      {:ok, res} =
      Web3MoveEx.Sui.unsafe_moveCall(
        client,
        acct,
        "0x7d12e10ef578e047e73a45b2949dffe3475997f2e5efc0beb10a2e51df16dce7",
        "air_dropper",
        "airdrop_coins_equal",
        ["0x2::sui::SUI"],
        [obj_id,
        ["0x9f8865b16348fd9e8ad4d42e6864bede1cceac0cde6324faaaa54539f86a58f0"],
        coin_num],
      "3000000")
      status = res.effects.status.status
      tx_id = res.digest
      %EventText{
        topic: "Character.Info",
        data: "web3_move_ex",
        text: ~i"""
          Airdropped #{coin_num} Sui /per Contributor for this Room(Repo)!
          tx status: #{status}
          tx_id: #{tx_id}
        """
      }
    end

    def render("_getobj",  obj_id) do

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
