defmodule Web.SessionController do
  use Web, :controller

  alias ExVenture.Users

  def new(conn, _params) do
    conn
    |> put_layout("session.html")
    |> assign(:changeset, Users.new())
    |> render("new.html")
  end

  def login(conn, %{"address" => address, "sig" => sig}) do
    with true <- verify_sig?(address, sig),
      true <- hold_nft?(address, "goosinals") do
        conn
    end
  end

  def verify_sig?(_addr, _sig), do: true
  def hold_nft?(_addr, _nft_type), do: true

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Users.validate_login(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You have signed in.")
        |> put_session(:user_token, user.token)
        |> after_sign_in_redirect(Routes.page_path(conn, :index))

      {:error, :invalid} ->
        conn
        |> put_flash(:error, "Your email or password is invalid")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @doc """
  Redirect to the last seen page after being asked to sign in

  Or the home page
  """
  def after_sign_in_redirect(conn, default_path) do
    case get_session(conn, :last_path) do
      nil ->
        redirect(conn, to: default_path)

      path ->
        conn
        |> put_session(:last_path, nil)
        |> redirect(to: path)
    end
  end
end
