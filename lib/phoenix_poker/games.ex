defmodule PhoenixPoker.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias PhoenixPoker.Repo

  alias PhoenixPoker.Games.GameNight

  @doc """
  Returns the list of game_nights.

  ## Examples

      iex> list_game_nights()
      [%GameNight{}, ...]

  """
  def list_game_nights do
    Repo.all(GameNight)
  end

  @doc """
  Gets a single game_night.

  Raises `Ecto.NoResultsError` if the Game night does not exist.

  ## Examples

      iex> get_game_night!(123)
      %GameNight{}

      iex> get_game_night!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_night!(id), do: Repo.get!(GameNight, id)

  @doc """
  Creates a game_night.

  ## Examples

      iex> create_game_night(%{field: value})
      {:ok, %GameNight{}}

      iex> create_game_night(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_night(attrs \\ %{}) do
    %GameNight{}
    |> GameNight.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_night.

  ## Examples

      iex> update_game_night(game_night, %{field: new_value})
      {:ok, %GameNight{}}

      iex> update_game_night(game_night, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_night(%GameNight{} = game_night, attrs) do
    game_night
    |> GameNight.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GameNight.

  ## Examples

      iex> delete_game_night(game_night)
      {:ok, %GameNight{}}

      iex> delete_game_night(game_night)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_night(%GameNight{} = game_night) do
    Repo.delete(game_night)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_night changes.

  ## Examples

      iex> change_game_night(game_night)
      %Ecto.Changeset{source: %GameNight{}}

  """
  def change_game_night(%GameNight{} = game_night) do
    GameNight.changeset(game_night, %{})
  end

  alias PhoenixPoker.Games.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{source: %Player{}}

  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{})
  end
end
