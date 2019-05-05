defmodule PhoenixPokerWeb.AttendeeResultControllerTest do
  use PhoenixPokerWeb.ConnCase

  alias PhoenixPoker.Games

  @create_attrs %{chips: 42, exact_cents: 42, game_night_id: 42, player_id: 42, rounded_cents: 42, rounding_style: "some rounding_style"}
  @update_attrs %{chips: 43, exact_cents: 43, game_night_id: 43, player_id: 43, rounded_cents: 43, rounding_style: "some updated rounding_style"}
  @invalid_attrs %{chips: nil, exact_cents: nil, game_night_id: nil, player_id: nil, rounded_cents: nil, rounding_style: nil}

  def fixture(:attendee_result) do
    {:ok, attendee_result} = Games.create_attendee_result(@create_attrs)
    attendee_result
  end

  describe "index" do
    test "lists all attendee_results", %{conn: conn} do
      conn = get(conn, Routes.attendee_result_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Attendee results"
    end
  end

  describe "new attendee_result" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.attendee_result_path(conn, :new))
      assert html_response(conn, 200) =~ "New Attendee result"
    end
  end

  describe "create attendee_result" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.attendee_result_path(conn, :create), attendee_result: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.attendee_result_path(conn, :show, id)

      conn = get(conn, Routes.attendee_result_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Attendee result"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.attendee_result_path(conn, :create), attendee_result: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Attendee result"
    end
  end

  describe "edit attendee_result" do
    setup [:create_attendee_result]

    test "renders form for editing chosen attendee_result", %{conn: conn, attendee_result: attendee_result} do
      conn = get(conn, Routes.attendee_result_path(conn, :edit, attendee_result))
      assert html_response(conn, 200) =~ "Edit Attendee result"
    end
  end

  describe "update attendee_result" do
    setup [:create_attendee_result]

    test "redirects when data is valid", %{conn: conn, attendee_result: attendee_result} do
      conn = put(conn, Routes.attendee_result_path(conn, :update, attendee_result), attendee_result: @update_attrs)
      assert redirected_to(conn) == Routes.attendee_result_path(conn, :show, attendee_result)

      conn = get(conn, Routes.attendee_result_path(conn, :show, attendee_result))
      assert html_response(conn, 200) =~ "some updated rounding_style"
    end

    test "renders errors when data is invalid", %{conn: conn, attendee_result: attendee_result} do
      conn = put(conn, Routes.attendee_result_path(conn, :update, attendee_result), attendee_result: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Attendee result"
    end
  end

  describe "delete attendee_result" do
    setup [:create_attendee_result]

    test "deletes chosen attendee_result", %{conn: conn, attendee_result: attendee_result} do
      conn = delete(conn, Routes.attendee_result_path(conn, :delete, attendee_result))
      assert redirected_to(conn) == Routes.attendee_result_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.attendee_result_path(conn, :show, attendee_result))
      end
    end
  end

  defp create_attendee_result(_) do
    attendee_result = fixture(:attendee_result)
    {:ok, attendee_result: attendee_result}
  end
end
