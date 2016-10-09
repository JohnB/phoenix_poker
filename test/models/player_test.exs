defmodule PhoenixPoker.PlayerTest do
  use PhoenixPoker.ModelCase

  alias PhoenixPoker.Player

  @valid_attrs %{nickname: "some content", email: 'whatever@whereever.com'}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
