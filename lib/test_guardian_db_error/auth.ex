defmodule TestGuardianDbError.Auth do
  import Plug.Conn
  def browser_login(conn, user) do
    conn
    |> build_authorization_payload(user)
    |> build_session
  end

  def browser_logout(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)

    conn
    |> Guardian.Plug.sign_out
    |> configure_session(drop: true)
  end

  def api_login(conn, student) do
    new_conn        = Guardian.Plug.api_sign_in(conn, student)
    jwt             = Guardian.Plug.current_token(new_conn)
    {:ok, claims}   = Guardian.Plug.claims(new_conn)
    exp             = Map.get(claims, "exp")

    new_conn
    |> put_resp_header("authorization", "Bearer #{jwt}") |> put_resp_header("x-expires", "#{exp}")

    %{jwt: jwt, claims: claims, exp: exp, conn: new_conn}
  end

  def api_logout(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)
    conn
  end

  def api_refresh(conn, params) do
    {:ok, existing_claims} = Guardian.Plug.claims(conn)
    existing_jwt = params["jwt"]
    student = params["student"]
    refresh = Guardian.refresh!(existing_jwt, existing_claims, %{ttl: {30, :days}})
    case refresh do
      {:ok, new_jwt, new_claims} ->
        new_exp = Map.get(new_claims, "exp")
        {:ok, new_jwt, new_exp, student}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp build_authorization_payload(conn, user) do
    new_conn        = Guardian.Plug.sign_in(conn, user)
    jwt             = Guardian.Plug.current_token(new_conn)
    {:ok, claims}   = Guardian.Plug.claims(new_conn)
    exp             = Map.get(claims, "exp")
    %{conn: new_conn, user: user, jwt: jwt, claims: claims, exp: exp}
  end

  defp build_session(%{conn: conn, user: user, jwt: jwt, claims: claims, exp: exp}) do
    conn
    |> put_session(:user_id, user.id)
    |> put_session(:jwt, jwt)
    |> put_session(:claims, claims)
    |> put_session(:exp, exp)
    |> assign(:current_user, user)
    |> configure_session(renew: true)
  end
end
