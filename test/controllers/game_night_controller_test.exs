defmodule PhoenixPoker.GameNightControllerTest do
  use PhoenixPoker.ConnCase

  alias PhoenixPoker.GameNight
  @valid_attrs %{buy_in_cents: 42, yyyymmdd: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, game_night_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing game nights"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, game_night_path(conn, :new)
    assert html_response(conn, 200) =~ "New game night"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, game_night_path(conn, :create), game_night: @valid_attrs
    assert redirected_to(conn) == game_night_path(conn, :index)
    assert Repo.get_by(GameNight, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, game_night_path(conn, :create), game_night: @invalid_attrs
    assert html_response(conn, 200) =~ "New game night"
  end

  test "shows chosen resource", %{conn: conn} do
    game_night = Repo.insert! %GameNight{}
    conn = get conn, game_night_path(conn, :show, game_night)
    assert html_response(conn, 200) =~ "Show game night"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, game_night_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    game_night = Repo.insert! %GameNight{}
    conn = get conn, game_night_path(conn, :edit, game_night)
    assert html_response(conn, 200) =~ "Edit game night"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    game_night = Repo.insert! %GameNight{}
    conn = put conn, game_night_path(conn, :update, game_night), game_night: @valid_attrs
    assert redirected_to(conn) == game_night_path(conn, :show, game_night)
    assert Repo.get_by(GameNight, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    game_night = Repo.insert! %GameNight{}
    conn = put conn, game_night_path(conn, :update, game_night), game_night: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit game night"
  end

  test "deletes chosen resource", %{conn: conn} do
    game_night = Repo.insert! %GameNight{}
    conn = delete conn, game_night_path(conn, :delete, game_night)
    assert redirected_to(conn) == game_night_path(conn, :index)
    refute Repo.get(GameNight, game_night.id)
  end
end
