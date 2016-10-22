defmodule PhoenixPoker.AttendeeResult do
  use PhoenixPoker.Web, :model

  schema "attendee_results" do
    field :chips, :integer
    field :exact_cents, :integer
    field :rounded_cents, :integer
    field :rounding_style, :string
    
    belongs_to :game_night, PhoenixPoker.GameNight
    belongs_to :player, PhoenixPoker.Player
    
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
