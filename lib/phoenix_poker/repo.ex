defmodule PhoenixPoker.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_poker,
    adapter: Ecto.Adapters.Postgres
end
