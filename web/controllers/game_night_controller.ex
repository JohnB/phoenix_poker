defmodule PhoenixPoker.GameNightController do
  use PhoenixPoker.Web, :controller

  alias PhoenixPoker.GameNight
  alias PhoenixPoker.Player
  import PhoenixPoker.Utils, only: [yyyymmdd_now: 0]

  def index(conn, _params) do
    game_nights = Repo.all(GameNight)
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
          |> put_flash(:info, "Inserted the #{yyyymmdd} game: #{inspect(struct)}.")
          |> redirect(to: game_night_path(conn, :show, struct))
        {:error, changeset} ->
          conn
          |> put_flash(:info, "Failed to inserted the #{yyyymmdd} game: #{inspect(changeset)}.")
          |> render("take_attendance.html", game_night: changeset, current_user: current_user)
      end
    end

    conn
    |> put_flash(:info, "Found the #{yyyymmdd} game: #{inspect(game_night)}.")
    |> redirect(to: game_night_path(conn, :show, game_night))
  end
  
  def current_attendance(conn, %{"id" => id}) do
    game_night = Repo.get!(GameNight, id)
    players = Repo.all(Player)
    render(conn, "current_attendance.html", game_night: game_night, players: players)
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
