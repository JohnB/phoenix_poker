defmodule PhoenixPoker.Utils do
  use Timex
  
  @moduledoc false

  def yyyymmdd_now() do
    now = Timex.now("-9")
    now.year * 10000 + now.month * 100 + now.day
  end
  
  def mailto_link(array_of_attendees) do
    emails = "john.baylor@gmail.com"
    subj = "Test email"
    body = "fancy table of results"
    "mailto:" <> emails <> "?subject=" <> subj <> "&body=" <> body <> ";"
  end
end
