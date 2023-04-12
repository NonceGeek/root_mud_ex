defmodule Web3MudExExample.Communication.BroadcastChannel do
  use Kalevala.Communication.Channel
end

defmodule Web3MudExExample.Communication do
  @moduledoc false

  use Kalevala.Communication

  @impl true
  def initial_channels() do
    [{"general", Web3MudExExample.Communication.BroadcastChannel, []}]
  end
end
