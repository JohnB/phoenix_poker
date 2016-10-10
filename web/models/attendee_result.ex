defmodule PhoenixPoker.AttendeeResult do
  use PhoenixPoker.Web, :model

  schema "attendee_results" do
    field :game_night_id, :integer
    field :player_id, :integer
    field :chips, :integer
    field :exact_cents, :integer
    field :rounded_cents, :integer
    field :rounding_style, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:game_night_id, :player_id, :chips, :exact_cents, :rounded_cents, :rounding_style])
    |> validate_required([:game_night_id, :player_id, :chips, :exact_cents, :rounded_cents, :rounding_style])
  end
end
