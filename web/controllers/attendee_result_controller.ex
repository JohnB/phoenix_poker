defmodule PhoenixPoker.AttendeeResultController do
  use PhoenixPoker.Web, :controller
  
  import Ecto
  alias Ecto.Multi

  alias PhoenixPoker.GameNight
  alias PhoenixPoker.AttendeeResult
  alias PhoenixPoker.Player
  
  def index(conn, _params) do
    attendee_results = Repo.all(AttendeeResult)
    render(conn, "index.html", attendee_results: attendee_results)
  end

  def new(conn, _params) do
    changeset = AttendeeResult.changeset(%AttendeeResult{})
    players = Repo.all(Player)
    render(conn, "new.html", players: players, changeset: changeset)
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

  def add_chips(conn, %{"id" => id, "cents" => cents}) do
    {chips_i, _} = Integer.parse(cents)
    attendee_result = Repo.get!(AttendeeResult, id)
    changeset = AttendeeResult.changeset(attendee_result, %{chips: attendee_result.chips + chips_i})
    next_page = game_night_path(conn, :cash_out_player, attendee_result.game_night_id, attendee_result.player_id)

    game_night = GameNight
                 |> Repo.get!(attendee_result.game_night_id)
                 |> Repo.preload([:attendee_results])
    attendee_results = game_night.attendee_results
    attendee_results_changeset = AttendeeResult.results_changeset(attendee_results)

    game_night = GameNight
                 |> Repo.get!(attendee_result.game_night_id)
                 |> Repo.preload([:attendee_results])

    case Repo.update(changeset) do
      {:ok, _} ->
        attendee_results = game_night.attendee_results
        attendee_results_changeset = AttendeeResult.results_changeset(attendee_results)
    
        multi = Multi.new
        |> Multi.update_all(:update_results, attendee_results_changeset)
        
        case PhoenixPoker.Repo.transaction(multi) do
          {:ok, %{update_results: _}} ->
            IO.puts "Succcess"
            conn
            |> redirect(to: next_page)
          {:error, failed_operation, failed_value, changes_so_far} ->
            IO.puts "Error"
            conn
            |> redirect(to: next_page)
        end
      {:error, _} ->
        conn
        |> put_flash(:info, "error adding chips.")
        |> redirect(to: next_page)
    end
  end

  def subtract_chips(conn, %{"id" => id, "cents" => cents}) do
    {chips_i, _} = Integer.parse(cents)
    attendee_result = Repo.get!(AttendeeResult, id)
    updated_chips = Enum.max([0, attendee_result.chips - chips_i])
    changeset = AttendeeResult.changeset(attendee_result, %{chips: updated_chips})
    next_page = game_night_path(conn, :cash_out_player, attendee_result.game_night_id, attendee_result.player_id)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> redirect(to: next_page)
      {:error, _} ->
        conn
        |> put_flash(:info, "error adding chips.")
        |> redirect(to: next_page)
    end
  end

  @doc """
  Batch-update attendee_results with the exact and rounded values.
  """
  def xresults_changeset(game_night_id) do
    game_night = GameNight
                 |> Repo.get!(game_night_id)
                 |> Repo.preload([:attendee_results])

    attendee_results = game_night.attendee_results
    num_players = Enum.count(attendee_results)
    total_buyin = Enum.map(attendee_results, fn(a_r) -> a_r.buy_in_cents end) |> Enum.sum
    total_chips = Enum.map(attendee_results, fn(a_r) -> a_r.chips end) |> Enum.sum

    exact_cents = Enum.map(attendee_results, fn(a_r) -> a_r.exact_cents end) |> Enum.sum
    rounded_1_cents = Enum.map(attendee_results, fn(a_r) -> a_r.rounded_cents end) |> Enum.sum

    changeset = Enum.map(attendee_results, fn(a_r) ->
      exact_cents = total_buyin * a_r.chips / total_chips
      AttendeeResult.changeset(a_r, %{
        exact_cents: exact_cents,
        rounded_cents: 100 * Float.round(exact_cents / 100),
      })
    end)
    
    multi = Multi.new
    |> Multi.update(:update_results, changeset)
    
    case PhoenixPoker.Repo.transaction(multi) do
      {:ok, %{update_results: _}} ->
        IO.puts "Succcess"
      {:error, failed_operation, failed_value, changes_so_far} ->
        IO.puts "Error"
    end
  end

end
