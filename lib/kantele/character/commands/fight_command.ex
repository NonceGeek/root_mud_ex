defmodule Kantele.Character.FightCommand do
  use Kalevala.Character.Command

  def run(conn, params) do
    params = %{
        name: params["name"],
      }
    
    conn
    |> event("fight/send", params) # change here?
    |> assign(:prompt, false)
  end
end
