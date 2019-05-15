defmodule PhoenixPoker.Games.AttendeeResult do
  use Ecto.Schema
  import Ecto.Changeset


  schema "attendee_results" do
    field :chips, :integer
    field :exact_cents, :integer
    belongs_to :game_night, PhoenixPoker.Games.GameNight
    belongs_to :player, PhoenixPoker.Games.Player
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
