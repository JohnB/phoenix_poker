defmodule PhoenixPoker.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :nickname, :string
      add :email, :string
      add :email_verified, :boolean, default: false, null: false

      timestamps()
    end

  end
end
