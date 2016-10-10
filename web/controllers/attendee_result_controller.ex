defmodule PhoenixPoker.AttendeeResultController do
  use PhoenixPoker.Web, :controller

  alias PhoenixPoker.AttendeeResult

  def index(conn, _params) do
    attendee_results = Repo.all(AttendeeResult)
    render(conn, "index.html", attendee_results: attendee_results)
  end

  def new(conn, _params) do
    changeset = AttendeeResult.changeset(%AttendeeResult{})
#    @players = Repo.all(Player)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"attendee_result" => attendee_result_params}) do
    changeset = AttendeeResult.changeset(%AttendeeResult{}, attendee_result_params)

    case Repo.insert(changeset) do
      {:ok, _attendee_result} ->
        conn
        |> put_flash(:info, "Attendee result created successfully.")
        |> redirect(to: attendee_result_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    attendee_result = Repo.get!(AttendeeResult, id)
    render(conn, "show.html", attendee_result: attendee_result)
  end

  def edit(conn, %{"id" => id}) do
    attendee_result = Repo.get!(AttendeeResult, id)
    changeset = AttendeeResult.changeset(attendee_result)
    render(conn, "edit.html", attendee_result: attendee_result, changeset: changeset)
  end

  def update(conn, %{"id" => id, "attendee_result" => attendee_result_params}) do
    attendee_result = Repo.get!(AttendeeResult, id)
    changeset = AttendeeResult.changeset(attendee_result, attendee_result_params)

    case Repo.update(changeset) do
      {:ok, attendee_result} ->
        conn
        |> put_flash(:info, "Attendee result updated successfully.")
        |> redirect(to: attendee_result_path(conn, :show, attendee_result))
      {:error, changeset} ->
        render(conn, "edit.html", attendee_result: attendee_result, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    attendee_result = Repo.get!(AttendeeResult, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(attendee_result)

    conn
    |> put_flash(:info, "Attendee result deleted successfully.")
    |> redirect(to: attendee_result_path(conn, :index))
  end
end
