defmodule PhoenixPoker.Repo.Migrations.CreateGameNight do
  use Ecto.Migration

  def change do
    create table(:game_nights) do
      add :yyyymmdd, :integer
      add :buy_in_cents, :integer

      timestamps()
    end

    create unique_index(:game_nights, [:yyyymmdd])
  end
end
