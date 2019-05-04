defmodule PhoenixPokerWeb.PageController do
  use PhoenixPokerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
