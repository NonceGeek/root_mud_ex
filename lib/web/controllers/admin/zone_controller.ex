defmodule Web.Admin.ZoneController do
  use Web, :controller

  alias ExVenture.StagedChanges
  alias ExVenture.Zones

  plug(Web.Plugs.ActiveTab, tab: :zones)
  plug(Web.Plugs.FetchPage when action in [:index])

  def index(conn, _params) do
    %{page: page, per: per} = conn.assigns

    %{page: zones, pagination: pagination} = Zones.all(page: page, per: per)

    conn
    |> assign(:zones, zones)
    |> assign(:pagination, pagination)
    |> assign(:path, Routes.admin_zone_path(conn, :index))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    case Zones.get(id) do
      {:ok, zone} ->
        conn
        |> assign(:zone, zone)
        |> assign(:mini_map, Zones.make_mini_map(zone))
        |> render("show.html")
    end
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Zones.new())
    |> render("new.html")
  end

  def create(conn, %{"zone" => params}) do
    case Zones.create(params) do
      {:ok, zone} ->
        conn
        |> put_flash(:info, "Zone created!")
        |> redirect(to: Routes.admin_zone_path(conn, :show, zone.id))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> put_flash(:error, "Could not save the zone")
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    case Zones.get(id) do
      {:ok, zone} ->
        conn
        |> assign(:zone, zone)
        |> assign(:changeset, Zones.edit(zone))
        |> render("edit.html")
    end
  end

  def update(conn, %{"id" => id, "zone" => params}) do
    {:ok, zone} = Zones.get(id)

    case Zones.update(zone, params) do
      {:ok, zone} ->
        conn
        |> put_flash(:info, "Zone created!")
        |> redirect(to: Routes.admin_zone_path(conn, :show, zone.id))

      {:error, changeset} ->
        conn
        |> assign(:zone, zone)
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> put_flash(:error, "Could not save the zone")
        |> render("edit.html")
    end
  end

  def publish(conn, %{"id" => id}) do
    {:ok, zone} = Zones.get(id)

    case Zones.publish(zone) do
      {:ok, zone} ->
        conn
        |> put_flash(:info, "Zone Published!")
        |> redirect(to: Routes.admin_zone_path(conn, :show, zone.id))
    end
  end

  def delete_changes(conn, %{"id" => id}) do
    {:ok, zone} = Zones.get(id)

    case StagedChanges.clear(zone) do
      {:ok, zone} ->
        redirect(conn, to: Routes.admin_zone_path(conn, :show, zone.id))
    end
  end
end
