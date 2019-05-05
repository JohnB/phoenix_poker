defmodule PhoenixPoker.Repo.Migrations.CreateAttendeeResults do
  use Ecto.Migration

  def change do
    create table(:attendee_results) do
      add :game_night_id, :integer
      add :player_id, :integer
      add :chips, :integer
      add :exact_cents, :integer
      add :rounded_cents, :integer
      add :rounding_style, :string

      timestamps()
    end

  end
end
