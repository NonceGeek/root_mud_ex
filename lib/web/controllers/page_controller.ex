defmodule Web.PageController do
  use Web, :controller

  alias Web3MUDEx.Characters

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def health(conn, _params) do
    send_resp(conn, 200, "OK")
  end

  def client(conn, _params) do
    %{current_user: user} = conn.assigns

    case Characters.all_for(user) do
      [] ->
        conn
        |> put_flash(:info, "Please create a character first!")
        |> redirect(to: Routes.profile_path(conn, :show))

      characters ->
        conn
        |> assign(:characters, characters)
        |> put_layout("simple.html")
        |> render("client.html")
    end
  end
end
