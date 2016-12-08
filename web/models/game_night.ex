defmodule PhoenixPoker.GameNight do
  use PhoenixPoker.Web, :model
  import PhoenixPoker.Utils, only: [yyyymmdd_now: 0]
  
  schema "game_nights" do
    field :yyyymmdd, :integer
    field :buy_in_cents, :integer
    
    has_many :attendee_results, PhoenixPoker.AttendeeResult

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
  
  def sorted_attendees(game_night) do
    Enum.sort(game_night.attendee_results, &(&1.player.nickname < &2.player.nickname) )
  end
  
  def in_the_past(game_night) do
    game_night.yyyymmdd < PhoenixPoker.Utils.yyyymmdd_now()
  end

end
