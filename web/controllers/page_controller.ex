defmodule PhoenixPoker.PageController do
  @moduledoc """
  Static page controller
  """

  use PhoenixPoker.Web, :controller
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    
    yyyymmdd = DateTime.utc_now.year * 10000 + DateTime.utc_now.month * 100 + DateTime.utc_now.day

    future = from g in PhoenixPoker.GameNight,
             where: g.yyyymmdd > ^yyyymmdd,
             order_by: [desc: :yyyymmdd]
#    current = from g in "game_nights",
#              where: g.yyyymmdd = yyyymmdd,
#              select: g.id, g.yyyymmdd
#    past = from g in "game_nights",
#           where: g.yyyymmdd < yyyymmdd,
#           select: g.id, g.yyyymmdd
              
    render( conn, "index.html",
      current_user: get_session(conn, :current_user),
#      future: Repo.all(PhoenixPoker.GameNight, where: "yyymmdd > #{:yyyymmdd}", order_by: "yyyymmdd DESC" ) #,
      future: Repo.all(future) #,
#      current: Repo.all(current),
#      past: Repo.all(past)
    )
  end
end
