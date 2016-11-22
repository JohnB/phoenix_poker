defmodule PhoenixPoker.GameNight do
  use PhoenixPoker.Web, :model
  
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
end
