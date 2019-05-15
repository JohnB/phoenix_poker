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
  

  def set_chipcount(conn, %{"id" => id, "chipcount" => chipcount}) do
    {chipcount_i, _} = Integer.parse(chipcount)
    attendee_result = Repo.get!(AttendeeResult, id)
    updated_chips = chipcount_i
    changeset = AttendeeResult.changeset(attendee_result, %{chips: updated_chips})

    case Repo.update(changeset) do
      {:ok, _} ->
        game_night = GameNight
                     |> Repo.get!(attendee_result.game_night_id)
                     |> Repo.preload([:attendee_results, attendee_results: :player])
    
        attendee_results = game_night.attendee_results
        attendee_results_changeset = AttendeeResult.results_changeset(attendee_results)
    
        Enum.each(attendee_results_changeset, fn(a_r) ->
          {:ok, _} = Repo.update(a_r)
        end )

        total_chips = max(1, Enum.map(attendee_results, fn(a_r) -> a_r.chips end) |> Enum.sum)
        rounded_1_cents = Enum.map(attendee_results, fn(a_r) -> a_r.rounded_cents end) |> Enum.sum
        selected_player_id_string = Integer.to_string(attendee_result.player_id)

        render_data = %{
          game_night: game_night,
          hostname: '',
          attendees: GameNight.sorted_attendees(game_night),
          historical_game: false,
          selected_player_id: -1,
          total_chips: total_chips / 100,
          exact_cents: attendee_result.exact_cents,
          rounded_1_cents: rounded_1_cents,
          chips_color: Utils.chips_color(game_night)
        }
        render(conn, PhoenixPoker.SharedView, "cash_out.html", render_data)
      {:error, _} ->
        next_page = Routes.game_night_path(conn, :cash_out_player, attendee_result.game_night_id, attendee_result.player_id)
        conn
        |> put_flash(:info, "error adding chips.")
        |> redirect(to: next_page)
    end
  end
end
