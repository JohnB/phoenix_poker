defmodule PhoenixPoker.GamesTest do
  use PhoenixPoker.DataCase

  alias PhoenixPoker.Games

  describe "game_nights" do
    alias PhoenixPoker.Games.GameNight

    @valid_attrs %{buy_in_cents: 42, yyyymmdd: 42}
    @update_attrs %{buy_in_cents: 43, yyyymmdd: 43}
    @invalid_attrs %{buy_in_cents: nil, yyyymmdd: nil}

    def game_night_fixture(attrs \\ %{}) do
      {:ok, game_night} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game_night()

      game_night
    end

    test "list_game_nights/0 returns all game_nights" do
      game_night = game_night_fixture()
      assert Games.list_game_nights() == [game_night]
    end

    test "get_game_night!/1 returns the game_night with given id" do
      game_night = game_night_fixture()
      assert Games.get_game_night!(game_night.id) == game_night
    end

    test "create_game_night/1 with valid data creates a game_night" do
      assert {:ok, %GameNight{} = game_night} = Games.create_game_night(@valid_attrs)
      assert game_night.buy_in_cents == 42
      assert game_night.yyyymmdd == 42
    end

    test "create_game_night/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game_night(@invalid_attrs)
    end

    test "update_game_night/2 with valid data updates the game_night" do
      game_night = game_night_fixture()
      assert {:ok, %GameNight{} = game_night} = Games.update_game_night(game_night, @update_attrs)
      assert game_night.buy_in_cents == 43
      assert game_night.yyyymmdd == 43
    end

    test "update_game_night/2 with invalid data returns error changeset" do
      game_night = game_night_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game_night(game_night, @invalid_attrs)
      assert game_night == Games.get_game_night!(game_night.id)
    end

    test "delete_game_night/1 deletes the game_night" do
      game_night = game_night_fixture()
      assert {:ok, %GameNight{}} = Games.delete_game_night(game_night)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game_night!(game_night.id) end
    end

    test "change_game_night/1 returns a game_night changeset" do
      game_night = game_night_fixture()
      assert %Ecto.Changeset{} = Games.change_game_night(game_night)
    end
  end
end
