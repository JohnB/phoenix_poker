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
  
  @doc """
  Builds a set of changesets based on the incoming attendee_results
  """
  def results_changeset(attendee_results) do
    num_players = Enum.count(attendee_results)
    total_buyin = 2500 * num_players
    total_chips = max(1, Enum.map(attendee_results, fn(a_r) -> a_r.chips end) |> Enum.sum)

    Enum.map(attendee_results, fn(a_r) ->
      exact_cents = total_buyin * a_r.chips / total_chips
      changeset(a_r, %{
        exact_cents: Kernel.round(exact_cents),
        rounded_cents: 100 * Kernel.round(exact_cents / 100),
      })
    end)
  end
end
