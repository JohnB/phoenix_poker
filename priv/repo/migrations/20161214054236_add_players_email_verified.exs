defmodule PhoenixPoker.Repo.Migrations.AddUserVerified do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :email_verified, :boolean
    end
  end
end
