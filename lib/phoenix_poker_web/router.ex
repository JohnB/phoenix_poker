defmodule PhoenixPokerWeb.Router do
  use PhoenixPokerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", PhoenixPokerWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    get "/logout", AuthController, :delete
    delete "/logout", AuthController, :delete
  end

  scope "/", PhoenixPokerWeb do
    pipe_through :browser
    get "/", PageController, :index

    resources "/game_nights", GameNightController
    resources "/players", PlayerController
    resources "/attendee_results", AttendeeResultController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixPokerWeb do
  #   pipe_through :api
  # end
end
