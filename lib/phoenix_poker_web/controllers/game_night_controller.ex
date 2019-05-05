defmodule PhoenixPokerWeb.GameNightController do
  use PhoenixPokerWeb, :controller

  alias PhoenixPoker.Games
  alias PhoenixPoker.Games.GameNight

  def index(conn, _params) do
    game_nights = Games.list_game_nights()
    render(conn, "index.html", game_nights: game_nights)
  end

  def new(conn, _params) do
    changeset = Games.change_game_night(%GameNight{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game_night" => game_night_params}) do
    case Games.create_game_night(game_night_params) do
      {:ok, game_night} ->
        conn
        |> put_flash(:info, "Game night created successfully.")
        |> redirect(to: Routes.game_night_path(conn, :show, game_night))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game_night = Games.get_game_night!(id)
    render(conn, "show.html", game_night: game_night)
  end

  def edit(conn, %{"id" => id}) do
    game_night = Games.get_game_night!(id)
    changeset = Games.change_game_night(game_night)
    render(conn, "edit.html", game_night: game_night, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game_night" => game_night_params}) do
    game_night = Games.get_game_night!(id)

    case Games.update_game_night(game_night, game_night_params) do
      {:ok, game_night} ->
        conn
        |> put_flash(:info, "Game night updated successfully.")
        |> redirect(to: Routes.game_night_path(conn, :show, game_night))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game_night: game_night, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_night = Games.get_game_night!(id)
    {:ok, _game_night} = Games.delete_game_night(game_night)

    conn
    |> put_flash(:info, "Game night deleted successfully.")
    |> redirect(to: Routes.game_night_path(conn, :index))
  end
end
