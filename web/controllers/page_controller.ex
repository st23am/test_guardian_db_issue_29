defmodule TestGuardianDbError.PageController do
  use TestGuardianDbError.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
