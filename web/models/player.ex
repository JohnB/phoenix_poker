defmodule PhoenixPoker.Player do
  use PhoenixPoker.Web, :model

  schema "players" do
    field :nickname, :string
    field :email, :string
    field :email_verified, :boolean

    has_many :attendee_results, PhoenixPoker.AttendeeResult

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nickname, :email, :email_verified])
    |> validate_required([:nickname, :email, :email_verified])
  end
end
