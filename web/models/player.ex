defmodule PhoenixPoker.Player do
  use PhoenixPoker.Web, :model

  schema "players" do
    field :nickname, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nickname, :email])
    |> validate_required([:nickname, :email])
  end
end
