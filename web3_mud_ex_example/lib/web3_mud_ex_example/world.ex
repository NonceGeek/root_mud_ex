defmodule Web3MudExExample.World do
  @moduledoc """
  GenServer to load and boot the world
  """

  use Supervisor

  alias Web3MudExExample.World.Loader
  alias Web3MudExExample.World.ZoneCache

  defstruct characters: [], items: [], rooms: [], zones: []

  @doc """
  Dereference a world variable reference
  """
  def dereference(reference) when is_binary(reference) do
    dereference(String.split(reference, "."))
  end

  def dereference([zone_id | reference]) do
    case ZoneCache.get(zone_id) do
      {:ok, zone} ->
        Loader.dereference(zone, reference)

      _ ->
        :error
    end
  end

  @doc false
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(_opts) do
    config = Application.get_env(:web3_mud_ex_example, :world, [])
    kickoff = Keyword.get(config, :kickoff, true)

    children = [
      {ZoneCache, [id: ZoneCache, name: ZoneCache]},
      {Web3MudExExample.World.Items, [id: Web3MudExExample.World.Items, name: Web3MudExExample.World.Items]},
      {Kalevala.World, [name: Web3MudExExample.World]},
      {Web3MudExExample.World.Kickoff, [name: Web3MudExExample.World.Kickoff, start: kickoff]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
