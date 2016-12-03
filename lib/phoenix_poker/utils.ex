defmodule PhoenixPoker.Utils do
  use Timex
  
  @moduledoc false

  def yyyymmdd_now() do
    now = Timex.now("-9")
    now.year * 10000 + now.month * 100 + now.day
  end
  
  def dollars_n_cents(cents) do
    '$' ++ Float.to_string(cents / 100)
  end

  def mailto_link(game_night) do
    subj = "Poker Results: #{game_night.yyyymmdd}"

    emails = Enum.map(game_night.attendee_results, fn(a_r) ->
      a_r.player.email
    end)
    |> Enum.join(",")
    
    body = Enum.sort(game_night.attendee_results, &(chips_n_name(&1) < chips_n_name(&2)) )
    |> Enum.map(fn(a_r) -> email_row(a_r) end)
    |> Enum.join("\n")

    "mailto:" <> emails <>
    "?subject=" <> subj <>
    "&body=" <> body <> ";"
  end
  
  # To get chips ordered *descending* but names *ascending* we subtract
  # from a huge number so we can sort it all *ascending*.
  def chips_n_name(a_r) do
    "#{1_000_000 - a_r.chips} #{a_r.player.nickname}"
  end
  
  def email_row(a_r) do
    " #{a_r.player.nickname}: $#{
      round(a_r.rounded_cents / 100)} (#{
      a_r.chips / 100} chips / $#{
      a_r.exact_cents / 100}) <br /> "
  end

end
