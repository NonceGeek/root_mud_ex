defmodule Web.Admin.UserController do
  use Web, :controller

  alias Web3MUDEx.Users

  plug(Web.Plugs.ActiveTab, tab: :users)
  plug(Web.Plugs.FetchPage when action in [:index])

  def index(conn, _params) do
    %{page: page, per: per} = conn.assigns
    %{page: users, pagination: pagination} = Users.all(page: page, per: per)

    conn
    |> assign(:users, users)
    |> assign(:pagination, pagination)
    |> assign(:path, Routes.admin_user_path(conn, :index))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    {:ok, user} = Users.get(id)

    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
