defmodule PhoenixPoker.GameNightController do
  use PhoenixPoker.Web, :controller

  import PhoenixPoker.Utils
  alias PhoenixPoker.Utils
  alias PhoenixPoker.GameNight
  alias PhoenixPoker.Player
  alias PhoenixPoker.AttendeeResult
  alias PhoenixPoker.Mailer

  def index(conn, _params) do
    query = from(
      g in GameNight,
      join: ar in AttendeeResult,
      on: ar.game_night_id == g.id,
      select: %{g | player_count: count(ar.id), total_chips: sum(ar.chips)},
      group_by: g.id,
      order_by: [desc: g.yyyymmdd]
    )
    game_nights = Repo.all(query)
    render(conn, "index.html", game_nights: game_nights)
  end

  def new(conn, _params) do
    yyyymmdd = yyyymmdd_now()
    changeset = GameNight.changeset(%GameNight{buy_in_cents: 2500, yyyymmdd: yyyymmdd})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game_night" => game_night_params}) do
    changeset = GameNight.changeset(%GameNight{}, game_night_params)

    case Repo.insert(changeset) do
      {:ok, _game_night} ->
        conn
        |> put_flash(:info, "Game night created successfully.")
        |> redirect(to: game_night_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game_night = Repo.get!(GameNight, id)
    render(conn, "show.html", game_night: game_night)
  end

  def take_attendance(conn, %{"yyyymmdd" => yyyymmdd}) do
    current_user = get_session(conn, :current_user)

    # Attempt at find-or-create
    query = from g in GameNight, where: g.yyyymmdd == ^yyyymmdd
    game_night = Repo.one(query)
    if !game_night do
      changeset = GameNight.changeset(%GameNight{}, %{buy_in_cents: 2500, yyyymmdd: yyyymmdd})
  
      case Repo.insert(changeset) do
        {:ok, struct} ->
          conn
          |> redirect(to: game_night_path(conn, :current_attendance, struct))
        {:error, changeset} ->
          conn
          |> put_flash(:info, "Failed to insert the #{yyyymmdd} game: #{inspect(changeset)}.")
          |> render("take_attendance.html", game_night: changeset, current_user: current_user)
      end
    else
      conn
      |> redirect(to: game_night_path(conn, :current_attendance, game_night))
    end
  end
  
  def current_attendance(conn, %{"id" => id}) do
    game_night = GameNight
                 |> Repo.get!(id)
                 |> Repo.preload([:attendee_results, attendee_results: :player])
    num_attendees = Enum.count(game_night.attendee_results)

    if num_attendees > 0 do
      cash_out_player(conn, %{"id" => id, "player_id" => -1})
    end
    
    players = Repo.all(from p in Player, order_by: p.nickname)
    render(conn, "current_attendance.html", game_night: game_night, players: players)
  end
  
  def cash_out(conn, %{"id" => id, "cash_out" => player_ids}) do
    # TODO: ensure this never gets called twice, so we do not
    # erase a game's result by accident.
    
    # Expect input like this:
    #   "cash_out" => %{"1" => "false", "2" => "true"}
    {gn_id, _} = Integer.parse(id)
    query = from ar in AttendeeResult,
      where: ar.game_night_id == ^gn_id
    Repo.delete_all(query)
    
    Enum.filter(player_ids, fn {_k, v} -> v == "true" end)
    |> Enum.map(fn {k, _v} ->
      AttendeeResult.changeset(%AttendeeResult{}, %{
          game_night_id: id,
          player_id: k,
          chips: 0,
          exact_cents: 0,
          rounded_cents: 0,
          rounding_style: "quarter"
        })
      |> PhoenixPoker.Repo.insert!
    end)
    
    game_night = GameNight
                 |> Repo.get!(id)
                 |> Repo.preload([:attendee_results, attendee_results: :player])
    historical_game = GameNight.in_the_past(game_night)
    attendees = if historical_game,
      do:   GameNight.sorted_attendees(game_night, :chips),
      else: GameNight.sorted_attendees(game_night)
       
    render(conn, PhoenixPoker.SharedView, "cash_out.html",
      game_night: game_night,
      hostname: '',
      attendees: attendees,
      historical_game: historical_game,
      selected_player_id: -1,
      total_chips: 0.0,
      exact_cents: 0,
      rounded_1_cents: 0,
      chips_color: ""
    )
  end
  
  def cash_out_player(conn, %{"id" => id, "player_id" => player_id}) do
    
    game_night = GameNight
                 |> Repo.get!(id)
                 |> Repo.preload([:attendee_results, attendee_results: :player])
    historical_game = GameNight.in_the_past(game_night)
    attendees = if historical_game,
      do:   GameNight.sorted_attendees(game_night, :chips),
      else: GameNight.sorted_attendees(game_night)

    render_data = %{
      game_night: game_night,
      hostname: '',
      attendees: attendees,
      historical_game: historical_game,
      selected_player_id: player_id,
      total_chips: Utils.total_chips(game_night) / 100,
      exact_cents: Utils.exact_cents(game_night),
      rounded_1_cents: Utils.rounded_1_cents(game_night),
      chips_color: Utils.chips_color(game_night)
    }
    render(conn, PhoenixPoker.SharedView, "cash_out.html", render_data)
  end

  def send_results(conn, %{"id" => id}) do
    game_night = GameNight
                 |> Repo.get!(id)
                 |> Repo.preload([:attendee_results, attendee_results: :player])
    
    hostname = PhoenixPoker.Router.Helpers.url(conn)
    PhoenixPoker.Email.poker_results_email(game_night, hostname)
    |> Mailer.deliver_now

    players = Repo.all(Player)
    render(conn, "send_results.html", game_night: game_night, players: players)
  end

  def edit(conn, %{"id" => id}) do
    game_night = Repo.get!(GameNight, id)
    changeset = GameNight.changeset(game_night)
    render(conn, "edit.html", game_night: game_night, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game_night" => game_night_params}) do
    game_night = Repo.get!(GameNight, id)
    changeset = GameNight.changeset(game_night, game_night_params)

    case Repo.update(changeset) do
      {:ok, game_night} ->
        conn
        |> put_flash(:info, "Game night updated successfully.")
        |> redirect(to: game_night_path(conn, :show, game_night))
      {:error, changeset} ->
        render(conn, "edit.html", game_night: game_night, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_night = Repo.get!(GameNight, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game_night)

    conn
    |> put_flash(:info, "Game night deleted successfully.")
    |> redirect(to: game_night_path(conn, :index))
  end
end
