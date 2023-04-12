defmodule Web3MudExExample.Character.RegistrationController do
  @moduledoc """
  Register the username you provided during the LoginController
  """

  use Kalevala.Character.Controller

  require Logger

  alias Web3MudExExample.Accounts
  alias Web3MudExExample.Character.CharacterController
  alias Web3MudExExample.Character.LoginView
  alias Web3MudExExample.Character.RegistrationView

  @impl true
  def init(conn) do
    conn
    |> send_option(:echo, true)
    |> prompt(RegistrationView, "password")
  end

  @impl true
  def recv_event(conn, _event), do: conn

  @impl true
  def recv(conn, ""), do: conn

  def recv(conn, data) do
    data = String.trim(data)

    process_password(conn, data)
  end

  defp process_password(conn, password) do
    username = get_flash(conn, :username)

    case Accounts.register(username, password) do
      {:ok, account} ->
        Logger.info("Created account: \"#{account.username}\"")

        conn
        |> put_flash(:login_state, :character)
        |> send_option(:echo, false)
        |> put_controller(CharacterController)
        |> render(LoginView, "signed-in")
    end
  end
end
