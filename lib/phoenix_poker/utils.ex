defmodule PhoenixPoker.Utils do
  use Timex
  
  @moduledoc false

  def yyyymmdd_now() do
    now = Timex.now("-9")
    now.year * 10000 + now.month * 100 + now.day
  end
  
  def dollars_n_cents(cents) do
    '$' ++ :erlang.float_to_binary(cents / 100, decimals: 2)
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
  
  # Return the number of chips (in cents) counted by all players
  def total_chips(game_night) do
    Enum.map(game_night.attendee_results, fn(a_r) -> a_r.chips end) |> Enum.sum
  end
  
  # Return the total number of cents that should be divvied up
  # (this is just verification of the math - it should be ~$25 per player)
  def exact_cents(game_night) do
    Enum.map(game_night.attendee_results, fn(a_r) -> a_r.exact_cents end) |> Enum.sum
  end
  
  # Return the rounded-to-dollar amount of cents that should be divvied up.
  # (this is just verification of the math - it should be ~$25 per player)
  def rounded_1_cents(game_night) do
    Enum.map(game_night.attendee_results, fn(a_r) -> a_r.rounded_cents end) |> Enum.sum
  end
  
  # Return a CSS class name to ensure we don't undercount (again)
  def chips_color(game_night) do
    num_attendees = Enum.count(game_night.attendee_results)
    initial_chips_in_cents = 40_00 # 4x$5 + 10x$1 + 10x50c + 20x25c (20+10+5+5)
    expected_chips = initial_chips_in_cents * num_attendees

    if (total_chips(game_night) < expected_chips) do 'chips_too_low' else '' end
  end
  
  # To get chips ordered *descending* but names *ascending* we subtract
  # from a huge number so we can sort it all *ascending*.
  def chips_n_name(a_r) do
    "#{1_000_000 - a_r.chips} #{a_r.player.nickname}"
  end
  
  def email_row(a_r) do
    " #{a_r.player.nickname}: $#{
      round(a_r.rounded_cents / 100)} (#{
      :erlang.float_to_binary(a_r.chips / 100, decimals: 2)} chips / $#{
      :erlang.float_to_binary(a_r.exact_cents / 100, decimals: 2)}) <br /> "
  end

end
