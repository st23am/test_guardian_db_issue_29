defmodule TestGuardianDbError.SessionController do
  use TestGuardianDbError.Web, :controller
  alias TestGuardianDbError.{User, Auth, LayoutView}
  alias Guardian.Plug.EnsureNotAuthenticated
  plug Guardian.Plug.VerifySession
  plug EnsureNotAuthenticated, [handler: __MODULE__] when action in [:new, :create]

  def new(conn, _) do
    render(conn, "login.html" )
  end

  def create(conn, %{"session" => session}) do
    case User.find_and_confirm_password(session) do
      {:ok, user} ->
        conn
        |> Auth.browser_login(user)
        |> redirect(to: dashboard_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid email/password")
        |> put_status(401)
        |> render("login.html")
    end
  end

  def destroy(conn, _) do
    conn
    |> Auth.browser_logout
    |> put_status(302)
    |> redirect(to: session_path(conn, :new))
  end

  def unauthenticated(conn, _) do
    conn
    |> put_flash(:error, "Authentication Required")
    |> put_status(302)
    |> redirect(to: session_path(conn, :new))
  end

  def already_authenticated(conn, _) do
    conn
    |> put_status(302)
    |> redirect(to: dashboard_path(conn, :index))
  end
end
