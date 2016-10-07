defmodule PhoenixPoker.GameNight do
  use PhoenixPoker.Web, :model

  schema "game_nights" do
    field :yyyymmdd, :integer
    field :buy_in_cents, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:yyyymmdd, :buy_in_cents])
    |> validate_required([:yyyymmdd, :buy_in_cents])
  end
end
