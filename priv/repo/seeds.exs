{:ok, _api_token} =
  Web3MUDEx.APIKeys.create(%{
    token: "6e8d83d9-a028-4eb7-bc7b-9b32bac697b6",
    is_active: true
  })

{:ok, _user} =
  Web3MUDEx.Users.create(%{
    username: "user",
    email: "user@example.com",
    password: "password",
    password_confirmation: "password"
  })

{:ok, admin} =
  Web3MUDEx.Users.create(%{
    username: "admin",
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password"
  })

{:ok, _admin} =
  admin
  |> Ecto.Changeset.change(%{role: "admin"})
  |> Web3MUDEx.Repo.update()

#
# The World
#

defmodule Seeds do
  alias Web3MUDEx.Rooms
  alias Web3MUDEx.Zones

  def create_zone(%{seed?: false}), do: :ok

  def create_zone(zone_data) do
    {:ok, zone} =
      Zones.create(%{
        key: zone_data.id,
        name: zone_data.name,
        description: zone_data.name
      })

    {:ok, zone} = Zones.publish(zone)

    Enum.each(zone_data.rooms, fn room ->
      create_room(zone, room)
    end)
  end

  def create_room(zone, params) do
    {:ok, room} =
      Rooms.create(zone, %{
        key: params.key,
        name: params.name,
        description: params.description,
        listen: params.description,
        map_icon: params.map_icon,
        x: params.x,
        y: params.y,
        z: params.z
      })

    {:ok, _room} = Web3MUDEx.Rooms.publish(room)
  end
end

world = NonceGeekDAO.World.Loader.load()

Enum.each(world.zones, fn zone ->
  Seeds.create_zone(zone)
end)
