defmodule PhoenixPoker.Games.GameNight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_nights" do
    field :buy_in_cents, :integer
    field :yyyymmdd, :integer

    timestamps()
  end

  @doc false
  def changeset(game_night, attrs) do
    game_night
    |> cast(attrs, [:yyyymmdd, :buy_in_cents])
    |> validate_required([:yyyymmdd, :buy_in_cents])
  end
end
