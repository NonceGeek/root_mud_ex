defmodule Web3MUDEx.Rooms.Room do
  @moduledoc """
  Schema for Rooms
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Web3MUDEx.Rooms
  alias Web3MUDEx.StagedChanges.StagedChange
  alias Web3MUDEx.Zones.Zone

  @map_colors ["blue", "brown", "green", "yellow"]

  def map_colors(), do: @map_colors

  schema "rooms" do
    field(:key, :string)

    field(:live_at, :utc_datetime)

    field(:name, :string)
    field(:description, :string)
    field(:listen, :string)

    field(:map_color, :string)
    field(:map_icon, :string)

    field(:x, :integer)
    field(:y, :integer)
    field(:z, :integer)

    field(:notes, :string)

    belongs_to(:zone, Zone)

    has_many(:staged_changes, {"room_staged_changes", StagedChange}, foreign_key: :struct_id)

    # emebeds features

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :key,
      :name,
      :description,
      :listen,
      :map_color,
      :map_icon,
      :notes,
      :x,
      :y,
      :z
    ])
    |> validate_required([:key, :name, :description, :listen, :x, :y, :z, :zone_id])
    |> validate_inclusion(:map_color, @map_colors)
    |> validate_inclusion(:map_icon, Rooms.available_map_icons())
    |> foreign_key_constraint(:zone_id)
    |> unique_constraint(:key)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [
      :key,
      :name,
      :description,
      :listen,
      :map_color,
      :map_icon,
      :notes,
      :x,
      :y,
      :z
    ])
    |> validate_required([:key, :name, :description, :listen, :x, :y, :z, :zone_id])
    |> validate_inclusion(:map_color, @map_colors)
    |> validate_inclusion(:map_icon, Rooms.available_map_icons())
    |> foreign_key_constraint(:zone_id)
    |> unique_constraint(:key)
  end

  def publish_changeset(struct) do
    struct
    |> change()
    |> put_change(:live_at, DateTime.truncate(DateTime.utc_now(), :second))
  end
end

defmodule Web3MUDEx.Rooms do
  @moduledoc """
  CRUD Rooms
  """

  import Ecto.Query

  alias Web3MUDEx.Repo
  alias Web3MUDEx.Rooms.Room
  alias Web3MUDEx.StagedChanges

  defdelegate map_colors(), to: Room

  def new(zone), do: zone |> Ecto.build_assoc(:rooms) |> Ecto.Changeset.change(%{})

  def edit(room), do: Ecto.Changeset.change(room, %{})

  @doc """
  Get all rooms, paginated
  """
  def all(opts) do
    opts = Enum.into(opts, %{})

    Room
    |> order_by([r], asc: r.zone_id, asc: r.name)
    |> preload([:staged_changes, :zone])
    |> Repo.paginate(opts[:page], opts[:per])
    |> staged_changes()
  end

  @doc """
  Get all rooms for a zone, paginated
  """
  def all(zone, opts) do
    opts = Enum.into(opts, %{})

    Room
    |> where([r], r.zone_id == ^zone.id)
    |> order_by([r], asc: r.name)
    |> preload([:staged_changes, :zone])
    |> Repo.paginate(opts[:page], opts[:per])
    |> staged_changes()
  end

  defp staged_changes(%{page: rooms, pagination: pagination}) do
    rooms = Enum.map(rooms, &StagedChanges.apply/1)
    %{page: rooms, pagination: pagination}
  end

  defp staged_changes(rooms) do
    Enum.map(rooms, &StagedChanges.apply/1)
  end

  @doc """
  Get a room
  """
  def get(id) do
    case Repo.get(Room, id) do
      nil ->
        {:error, :not_found}

      room ->
        room =
          room
          |> Repo.preload([:staged_changes, zone: [:staged_changes]])
          |> StagedChanges.apply()
          |> StagedChanges.apply(:zone)

        {:ok, room}
    end
  end

  @doc """
  Create a new room
  """
  def create(zone, params) do
    zone
    |> Ecto.build_assoc(:rooms)
    |> Room.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update a room
  """
  def update(%{live_at: nil} = room, params) do
    room
    |> Room.update_changeset(params)
    |> Repo.update()
  end

  def update(room, params) do
    room
    |> Room.update_changeset(params)
    |> StagedChanges.record_changes()
  end

  @doc """
  Publish the room

  When a room is published, it will startup inside the game.
  """
  def publish(room) do
    room
    |> Room.publish_changeset()
    |> Repo.update()
  end

  @doc """
  Get a list of all available icons
  """
  def available_map_icons() do
    :code.priv_dir(:web3_mud_ex)
    |> Path.join("static/images/map-icons/*")
    |> Path.wildcard()
    |> Enum.map(fn file ->
      Path.basename(file, Path.extname(file))
    end)
  end
end
