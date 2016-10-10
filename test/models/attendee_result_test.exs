defmodule PhoenixPoker.AttendeeResultTest do
  use PhoenixPoker.ModelCase

  alias PhoenixPoker.AttendeeResult

  @valid_attrs %{chips: 42, exact_cents: 42, game_night_id: 42, player_id: 42, rounded_cents: 42, rounding_style: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AttendeeResult.changeset(%AttendeeResult{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AttendeeResult.changeset(%AttendeeResult{}, @invalid_attrs)
    refute changeset.valid?
  end
end
