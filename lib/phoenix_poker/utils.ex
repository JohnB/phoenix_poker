defmodule PhoenixPoker.Utils do
  @moduledoc false

  def yyyymmdd_now() do
    DateTime.utc_now.year * 10000 + DateTime.utc_now.month * 100 + DateTime.utc_now.day
  end
end
