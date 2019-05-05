defmodule PhoenixPoker.Games.AttendeeResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attendee_results" do
    field :chips, :integer
    field :exact_cents, :integer
    field :game_night_id, :integer
    field :player_id, :integer
    field :rounded_cents, :integer
    field :rounding_style, :string

    timestamps()
  end

  @doc false
  def changeset(attendee_result, attrs) do
    attendee_result
    |> cast(attrs, [:game_night_id, :player_id, :chips, :exact_cents, :rounded_cents, :rounding_style])
    |> validate_required([:game_night_id, :player_id, :chips, :exact_cents, :rounded_cents, :rounding_style])
  end
end
