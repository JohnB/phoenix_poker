defmodule PhoenixPoker.Utils do
  use Timex
  
  @moduledoc false

  def yyyymmdd_now() do
    now = Timex.now("-9")
    now.year * 10000 + now.month * 100 + now.day
  end
end
