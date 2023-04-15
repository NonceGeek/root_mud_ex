defmodule Web.API.ZoneController do
  use Web, :controller

  alias Web3MUDEx.Zones

  plug(Web.Plugs.FetchPage when action in [:index])

  def index(conn, _params) do
    %{page: page, per: per} = conn.assigns

    %{page: zones, pagination: pagination} = Zones.all(page: page, per: per)

    conn
    |> assign(:zones, zones)
    |> assign(:pagination, pagination)
    |> render("index.json")
  end

  def show(conn, %{"id" => id}) do
    case Zones.get(id) do
      {:ok, zone} ->
        conn
        |> assign(:zone, zone)
        |> render("show.json")

      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> put_view(Web.ErrorView)
        |> render("404.json")
    end
  end
end
