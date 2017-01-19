defmodule TestGuardianDbError.Router do
  use TestGuardianDbError.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_authenticated do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: TestGuardianDbError.SessionController
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestGuardianDbError do
    pipe_through :browser # Use the default browser stack

    get "/sessions", SessionController, :new # login to admin site
    get "/", SessionController, :new
    post "/sessions", SessionController, :create

    scope "/protected/" do
      pipe_through :browser_authenticated

      get "/dashboard", DashboardController, :index
      delete "/logout", SessionController, :destroy
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestGuardianDbError do
  #   pipe_through :api
  # end
end
