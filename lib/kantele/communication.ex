defmodule NonceGeekDAO.Communication.BroadcastChannel do
  use Kalevala.Communication.Channel
end

defmodule NonceGeekDAO.Communication do
  @moduledoc false

  use Kalevala.Communication

  @impl true
  def initial_channels() do
    [{"general", NonceGeekDAO.Communication.BroadcastChannel, []}]
  end
end
