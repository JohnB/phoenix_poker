defmodule PhoenixPoker.Utils do
  use Timex
  
  @moduledoc false

  def yyyymmdd_now() do
    now = Timex.now("-9")
    now.year * 10000 + now.month * 100 + now.day
  end
  
  def mailto_link(game_night) do
    subj = "Poker Results: #{game_night.yyyymmdd}"

    emails = Enum.map(game_night.attendee_results, fn(a_r) ->
      a_r.player.email
    end)
    |> Enum.join(",")
    
    body = Enum.map(game_night.attendee_results, fn(a_r) ->
      " #{a_r.player.nickname}: $#{
        a_r.rounded_cents / 100} (#{
        a_r.chips / 100} chips / $#{
        a_r.exact_cents / 100}) <br /> "
    end)
    |> Enum.join("\n")

    "mailto:" <> emails <>
    "?subject=" <> subj <>
    "&body=" <> body <> ";"
  end
end
