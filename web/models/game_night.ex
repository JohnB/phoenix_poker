defmodule PhoenixPoker.GameNight do
  use PhoenixPoker.Web, :model
  
  schema "game_nights" do
    field :yyyymmdd, :integer
    field :buy_in_cents, :integer
    field :player_count, :integer, virtual: true
    
    has_many :attendee_results, PhoenixPoker.AttendeeResult
    # Why doesn't ecto have a has_many_through option?
    # has_many :players, PhoenixPoker.Player, through: AttendeeResult

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:yyyymmdd, :buy_in_cents])
    |> unique_constraint(:yyyymmdd)
    |> validate_required([:yyyymmdd, :buy_in_cents])
  end
  
  def sorted_attendees(game_night, :chips) do
    Enum.sort(game_night.attendee_results, &(&1.chips > &2.chips) )
  end
  def sorted_attendees(game_night) do
    Enum.sort(game_night.attendee_results, &sort_lowest_then_chips_then_name/2 )
  end

  # When entering the chips, sort the already-entered from top to bottom but
  # keep the un-set players at the top of the list.
  def sort_lowest_then_chips_then_name(a, b) do
    case [a.chips, b.chips] do
      [0, 0] -> (a.player.nickname < b.player.nickname)
      [0, _] -> true
      [_, 0] -> false
      [n, n] -> (a.player.nickname < b.player.nickname)
      [_, _] -> (a.chips > b.chips)
    end
  end
  
  def in_the_past(game_night) do
    game_night.yyyymmdd < PhoenixPoker.Utils.yyyymmdd_now()
  end

end
