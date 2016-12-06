defmodule PhoenixPoker.Email do
  use Bamboo.Phoenix, view: PhoenixPoker.EmailView
  
  def welcome_text_email(email_address) do
    new_email
    |> to(email_address)
    |> from("john.baylor@gmail.com")
    |> subject("Welcome!")
    |> text_body("Welcome to PhoenixPoker!")
  end
end
