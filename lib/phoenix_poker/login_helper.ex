defmodule PhoenixPoker.LoginHelper do
  use PhoenixPoker.Web, :controller

  def current_user(conn) do
    get_session(conn, :current_user)
#    Guardian.Plug.current_resource(conn)
  end

#  def logged_in?(conn) do
#    Guardian.Plug.authenticated?(conn)
#  end
end
