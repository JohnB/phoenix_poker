defmodule PhoenixPoker.GameNightTest do
  use PhoenixPoker.ModelCase

  alias PhoenixPoker.GameNight

  @valid_attrs %{buy_in_cents: 42, yyyymmdd: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GameNight.changeset(%GameNight{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GameNight.changeset(%GameNight{}, @invalid_attrs)
    refute changeset.valid?
  end
end
