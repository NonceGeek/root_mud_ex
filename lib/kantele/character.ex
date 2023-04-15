defmodule NonceGeekDAO.Character.PlayerMeta do
  @moduledoc """
  Specific metadata for a character in NonceGeekDAO
  """

  defstruct [:reply_to, :vitals]

  defimpl Kalevala.Meta.Trim do
    def trim(meta) do
      Map.take(meta, [:vitals])
    end
  end

  defimpl Kalevala.Meta.Access do
    def get(meta, key), do: Map.get(meta, key)

    def put(meta, key, value), do: Map.put(meta, key, value)
  end
end

defmodule NonceGeekDAO.Character.NonPlayerMeta do
  @moduledoc """
  Specific metadata for a world character in NonceGeekDAO
  """

  defstruct [:initial_events, :vitals, :zone_id]

  defimpl Kalevala.Meta.Trim do
    def trim(meta) do
      Map.take(meta, [:vitals])
    end
  end

  defimpl Kalevala.Meta.Access do
    def get(meta, key), do: Map.get(meta, key)

    def put(meta, key, value), do: Map.put(meta, key, value)
  end
end

defmodule NonceGeekDAO.Character.Vitals do
  @moduledoc """
  Character vital information
  """

  @derive Jason.Encoder
  defstruct [
    :priv,
    :sui_addr,
    :health_points,
    :max_health_points,
    :skill_points,
    :max_skill_points,
    :endurance_points,
    :max_endurance_points
  ]
end

defmodule NonceGeekDAO.Character.InitialEvent do
  @moduledoc """
  Initial events to kick off when a character starts
  """

  defstruct [:data, :delay, :topic]
end
