defmodule PhoenixPoker.Player do
  use PhoenixPoker.Web, :model

  schema "players" do
    field :nickname, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nickname])
    |> validate_required([:nickname])
  end
end
