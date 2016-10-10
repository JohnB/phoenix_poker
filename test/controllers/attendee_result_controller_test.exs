defmodule PhoenixPoker.AttendeeResultControllerTest do
  use PhoenixPoker.ConnCase

  alias PhoenixPoker.AttendeeResult
  @valid_attrs %{chips: 42, exact_cents: 42, game_night_id: 42, player_id: 42, rounded_cents: 42, rounding_style: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, attendee_result_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing attendee results"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, attendee_result_path(conn, :new)
    assert html_response(conn, 200) =~ "New attendee result"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, attendee_result_path(conn, :create), attendee_result: @valid_attrs
    assert redirected_to(conn) == attendee_result_path(conn, :index)
    assert Repo.get_by(AttendeeResult, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, attendee_result_path(conn, :create), attendee_result: @invalid_attrs
    assert html_response(conn, 200) =~ "New attendee result"
  end

  test "shows chosen resource", %{conn: conn} do
    attendee_result = Repo.insert! %AttendeeResult{}
    conn = get conn, attendee_result_path(conn, :show, attendee_result)
    assert html_response(conn, 200) =~ "Show attendee result"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, attendee_result_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    attendee_result = Repo.insert! %AttendeeResult{}
    conn = get conn, attendee_result_path(conn, :edit, attendee_result)
    assert html_response(conn, 200) =~ "Edit attendee result"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    attendee_result = Repo.insert! %AttendeeResult{}
    conn = put conn, attendee_result_path(conn, :update, attendee_result), attendee_result: @valid_attrs
    assert redirected_to(conn) == attendee_result_path(conn, :show, attendee_result)
    assert Repo.get_by(AttendeeResult, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    attendee_result = Repo.insert! %AttendeeResult{}
    conn = put conn, attendee_result_path(conn, :update, attendee_result), attendee_result: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit attendee result"
  end

  test "deletes chosen resource", %{conn: conn} do
    attendee_result = Repo.insert! %AttendeeResult{}
    conn = delete conn, attendee_result_path(conn, :delete, attendee_result)
    assert redirected_to(conn) == attendee_result_path(conn, :index)
    refute Repo.get(AttendeeResult, attendee_result.id)
  end
end
