defmodule NonceGeekDAO.Websocket.Endpoint do
  @moduledoc false

  use Plug.Router

  plug(Plug.Static,
    at: "/",
    gzip: true,
    only: ["css", "images", "js", "robots.txt"],
    from: :NonceGeekDAO
  )

  plug(:match)
  plug(:dispatch)

  match "/_health" do
    send_resp(conn, 200, "")
  end

  match _ do
    index_file = Path.join(:code.priv_dir(:NonceGeekDAO), "static/index.html")
    send_resp(conn, 200, File.read!(index_file))
  end
end
