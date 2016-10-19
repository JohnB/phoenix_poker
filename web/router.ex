defmodule PhoenixPoker.Router do
  @moduledoc false

  use PhoenixPoker.Web, :router
  require Ueberauth

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

  scope "/auth", PhoenixPoker do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", PhoenixPoker do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/players", PlayerController
    resources "/game_nights", GameNightController
    get "/game_nights/take_attendance/:yyyymmdd", GameNightController, :take_attendance
    get "/game_nights/current_attendance/:id", GameNightController, :current_attendance
    post "/game_nights/cash_out/:id", GameNightController, :cash_out
    post "/game_nights/send_results/:id", GameNightController, :send_results
    resources "/attendee_results", AttendeeResultController
  end
end
