defmodule PhoenixPoker.Email do
  use Bamboo.Phoenix, view: PhoenixPoker.EmailView
  
  def welcome_text_email(email_address, body \\ "Test from PhoenixPoker") do
    new_email
    |> to(email_address)
    |> from("john.baylor@gmail.com")
    |> subject("Welcome!")
    |> text_body(body)
  end
  
  def poker_results_email(game_night) do
    emails = Enum.map(game_night.attendee_results, fn(a_r) ->
      a_r.player.email
    end)
    |> Enum.join(",")
    
    body = Enum.sort(game_night.attendee_results, &(chips_n_name(&1) < chips_n_name(&2)) )
    |> Enum.map(fn(a_r) -> email_row(a_r) end)
    |> Enum.join("\n")
  
    new_email
    |> to(emails)
    |> from("john.baylor@gmail.com")
    |> subject("DEBUG Poker Results (SES): #{game_night.yyyymmdd}")
    |> text_body(body)
  end

  # To get chips ordered *descending* but names *ascending* we subtract
  # from a huge number so we can sort it all *ascending*.
  def chips_n_name(a_r) do
    "#{1_000_000 - a_r.chips} #{a_r.player.nickname}"
  end
  
  def email_row(a_r) do
    " #{a_r.player.nickname}: $#{
      round(a_r.rounded_cents / 100)} (#{
      Float.to_string(a_r.chips / 100, decimals: 2)} chips / $#{
      Float.to_string(a_r.exact_cents / 100, decimals: 2)}) <br /> "
  end
end

