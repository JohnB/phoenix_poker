defmodule PhoenixPoker.LoginHelper do
  use PhoenixPoker.Web, :controller

  def current_user(conn) do
    get_session(conn, :current_user)
    # Why is this commented out?
    # Guardian.Plug.current_resource(conn)
  end

  # The scaffolding CRUD UI is very powerful, so don't link
  # to it unless we should have that power.
  def can_access_scaffolding?(conn) do
    (current_user(conn).name == "John Baylor")
  end

  #  def logged_in?(conn) do
  #    Guardian.Plug.authenticated?(conn)
  #  end
end
