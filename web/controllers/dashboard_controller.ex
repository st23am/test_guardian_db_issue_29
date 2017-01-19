defmodule TestGuardianDbError.DashboardController do
  use TestGuardianDbError.Web, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
