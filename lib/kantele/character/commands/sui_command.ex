defmodule NonceGeekDAO.Character.SuiCommand do
  @doc """
    Commands about interactor with Sui.
  """

  use Kalevala.Character.Command

  alias Kalevala.Verb
  alias NonceGeekDAO.Character.SuiView
  alias Web3MoveEx.Sui

  def get_obj(conn, %{"obj_id" => obj_id}) do
    render(conn, SuiView, "getobj", %{obj_id: obj_id})
  end

  def get_obj_test(conn, %{"obj_id" => obj_id}) do
    render(conn, SuiView, "getobjtest", %{obj_id: obj_id})
  end

  def get_objs_by_owner(conn, %{"addr" => addr}) do
    render(conn, SuiView, "getobjsbyowner", %{addr: addr})
  end

  def get_contributors(conn, %{"room_name" => room_name}) do
    render(conn, SuiView, "getcontributors", %{room_name: room_name})
  end

  def airdrop(conn, %{"coin_num" => coin_num}) do
    render(conn, SuiView, "airdrop", %{coin_num: coin_num})
  end

end
