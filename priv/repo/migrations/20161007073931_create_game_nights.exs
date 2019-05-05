defmodule PhoenixPoker.Repo.Migrations.CreateGameNights do
  use Ecto.Migration

  def change do
    create table(:game_nights) do
      add :yyyymmdd, :integer
      add :buy_in_cents, :integer

      timestamps()
    end

  end
end
