defmodule PhoenixPoker.PageController do
  @moduledoc """
  Static page controller
  """

  use PhoenixPoker.Web, :controller
  import Ecto.Query, only: [from: 2]
  import PhoenixPoker.Utils, only: [yyyymmdd_now: 0]

  def index(conn, _params) do
    
    future = from g in PhoenixPoker.GameNight,
             where: g.yyyymmdd > ^yyyymmdd_now(),
             order_by: [desc: :yyyymmdd],
             limit: 10
    past = from g in PhoenixPoker.GameNight,
           where: g.yyyymmdd < ^yyyymmdd_now(),
           order_by: [desc: :yyyymmdd],
           limit: 10
              
    render( conn, "index.html",
      current_user: get_session(conn, :current_user),
      future: Repo.all(future),
      yyyymmdd: yyyymmdd_now(),
      past: Repo.all(past)
    )
  end
end
