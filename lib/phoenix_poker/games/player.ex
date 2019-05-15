defmodule PhoenixPoker.Games.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :email, :string
    field :email_verified, :boolean, default: false
    field :nickname, :string
    
    has_many :attendee_results, PhoenixPoker.Games.AttendeeResult

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :email, :email_verified])
    |> validate_required([:nickname, :email, :email_verified])
  end
end
