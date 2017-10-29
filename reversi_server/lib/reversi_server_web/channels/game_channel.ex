defmodule ReversiServerWeb.GameChannel do
  @moduledoc """
  Channel for a game.
  """
  require Logger
  use Phoenix.Channel

  alias ReversiBoard.{
    Playable,
    Step,
    Stones,
  }
  alias ReversiServer.{
    Game,
  }
  alias ReversiServer.Game.Supervisor, as: GameSupervisor

  @doc """
  Spawn new game via GameSupervisor unless started

  Returns %Game{} struct.
  """
  def join("game:" <> game_id, _message, socket) do
    player_id = socket.assigns.player_id

    case GameSupervisor.create_game(game_id) do
      {:ok, child} ->
        Logger.debug("Spawned worker: " <> inspect(child))
      {:error, {:already_started, child}} ->
        Logger.debug("already started:" <> inspect(child))
    end

    case Game.join(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        {:ok, game} = Game.get_data(game_id)
        {:ok, game, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  @doc """
  Handle add_step message for game_id

  Returns two consecuitive responses.
  The 1st response is asynchronous and the 2nd is synchronous.
  Both response messages are %Game{} struct.

  See also sequence diagram in `README.md`.
  """
  def handle_in("game:add_step", %{"x" => x, "y" => y, "stone" => stone} = _message, socket) do
    game_id = socket.assigns.game_id
    {:ok, game} = Game.add_step(game_id, x, y, stone)

    # 1st broadcast
    # Broadcast an event to all subscribers of the socket topic.
    broadcast socket, "game:state", game

    # Make computer step
    step_or_skip = Playable.make_step(game.player2, game.board, Stones.black)
    :timer.sleep(500)

    case step_or_skip do
      %Step{x: x, y: y, stone: stone} ->
        {:ok, game} = Game.add_step(game_id, x, y, stone)

        # 2nd broadcast
        broadcast socket, "game:state", game
    end

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug "Terminating GameChannel #{socket.assigns.game_id} #{inspect reason}"

    player_id = socket.assigns.player_id
    game_id = socket.assigns.game_id

    # case Game.player_left(game_id, player_id) do ...
    GameSupervisor.destroy_game(game_id)

    broadcast(socket, "game:over", %{game: "over"})
    broadcast(socket, "game:player_left", %{player_id: player_id})

    :ok
  end

end