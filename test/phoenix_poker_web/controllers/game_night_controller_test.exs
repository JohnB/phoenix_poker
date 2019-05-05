defmodule PhoenixPokerWeb.GameNightControllerTest do
  use PhoenixPokerWeb.ConnCase

  alias PhoenixPoker.Games

  @create_attrs %{buy_in_cents: 42, yyyymmdd: 42}
  @update_attrs %{buy_in_cents: 43, yyyymmdd: 43}
  @invalid_attrs %{buy_in_cents: nil, yyyymmdd: nil}

  def fixture(:game_night) do
    {:ok, game_night} = Games.create_game_night(@create_attrs)
    game_night
  end

  describe "index" do
    test "lists all game_nights", %{conn: conn} do
      conn = get(conn, Routes.game_night_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Game nights"
    end
  end

  describe "new game_night" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.game_night_path(conn, :new))
      assert html_response(conn, 200) =~ "New Game night"
    end
  end

  describe "create game_night" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_night_path(conn, :create), game_night: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_night_path(conn, :show, id)

      conn = get(conn, Routes.game_night_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Game night"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_night_path(conn, :create), game_night: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Game night"
    end
  end

  describe "edit game_night" do
    setup [:create_game_night]

    test "renders form for editing chosen game_night", %{conn: conn, game_night: game_night} do
      conn = get(conn, Routes.game_night_path(conn, :edit, game_night))
      assert html_response(conn, 200) =~ "Edit Game night"
    end
  end

  describe "update game_night" do
    setup [:create_game_night]

    test "redirects when data is valid", %{conn: conn, game_night: game_night} do
      conn = put(conn, Routes.game_night_path(conn, :update, game_night), game_night: @update_attrs)
      assert redirected_to(conn) == Routes.game_night_path(conn, :show, game_night)

      conn = get(conn, Routes.game_night_path(conn, :show, game_night))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, game_night: game_night} do
      conn = put(conn, Routes.game_night_path(conn, :update, game_night), game_night: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game night"
    end
  end

  describe "delete game_night" do
    setup [:create_game_night]

    test "deletes chosen game_night", %{conn: conn, game_night: game_night} do
      conn = delete(conn, Routes.game_night_path(conn, :delete, game_night))
      assert redirected_to(conn) == Routes.game_night_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.game_night_path(conn, :show, game_night))
      end
    end
  end

  defp create_game_night(_) do
    game_night = fixture(:game_night)
    {:ok, game_night: game_night}
  end
end
