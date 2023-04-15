defmodule NonceGeekDAO.Character.EmoteCommand do
  use Kalevala.Character.Command, dynamic: true

  alias NonceGeekDAO.Character.Emotes
  alias NonceGeekDAO.Character.EmoteAction
  alias NonceGeekDAO.Character.EmoteView

  @impl true
  def parse(text, _opts) do
    case Emotes.get(text) do
      {:ok, command} ->
        {:dynamic, :broadcast, %{"text" => command.text}}

      {:error, :not_found} ->
        :skip
    end
  end

  def broadcast(conn, params) do
    params = Map.put(params, "channel_name", "rooms:#{conn.character.room_id}")

    conn
    |> EmoteAction.run(params)
    |> assign(:prompt, false)
  end

  def list(conn, _params) do
    emotes = Enum.sort(Emotes.keys())

    render(conn, EmoteView, "list", %{emotes: emotes})
  end
end
