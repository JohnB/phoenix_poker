defmodule PhoenixPokerWeb.AttendeeResultController do
  use PhoenixPokerWeb, :controller

  alias PhoenixPoker.Games
  alias PhoenixPoker.Games.AttendeeResult

  def index(conn, _params) do
    attendee_results = Games.list_attendee_results()
    render(conn, "index.html", attendee_results: attendee_results)
  end

  def new(conn, _params) do
    changeset = Games.change_attendee_result(%AttendeeResult{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"attendee_result" => attendee_result_params}) do
    case Games.create_attendee_result(attendee_result_params) do
      {:ok, attendee_result} ->
        conn
        |> put_flash(:info, "Attendee result created successfully.")
        |> redirect(to: Routes.attendee_result_path(conn, :show, attendee_result))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    attendee_result = Games.get_attendee_result!(id)
    render(conn, "show.html", attendee_result: attendee_result)
  end

  def edit(conn, %{"id" => id}) do
    attendee_result = Games.get_attendee_result!(id)
    changeset = Games.change_attendee_result(attendee_result)
    render(conn, "edit.html", attendee_result: attendee_result, changeset: changeset)
  end

  def update(conn, %{"id" => id, "attendee_result" => attendee_result_params}) do
    attendee_result = Games.get_attendee_result!(id)

    case Games.update_attendee_result(attendee_result, attendee_result_params) do
      {:ok, attendee_result} ->
        conn
        |> put_flash(:info, "Attendee result updated successfully.")
        |> redirect(to: Routes.attendee_result_path(conn, :show, attendee_result))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", attendee_result: attendee_result, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    attendee_result = Games.get_attendee_result!(id)
    {:ok, _attendee_result} = Games.delete_attendee_result(attendee_result)

    conn
    |> put_flash(:info, "Attendee result deleted successfully.")
    |> redirect(to: Routes.attendee_result_path(conn, :index))
  end
end
