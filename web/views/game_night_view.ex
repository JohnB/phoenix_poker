defmodule PhoenixPoker.GameNightView do
  use PhoenixPoker.Web, :view
  
#  <% dollars_n_cents = fn {cents} -> '$' ++ Float.to_string(cents / 100) end %>
  def dollars_n_cents(cents) do
    '$' ++ Float.to_string(cents / 100)
  end

end
