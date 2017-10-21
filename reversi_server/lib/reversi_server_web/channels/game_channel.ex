defmodule ReversiServerWeb.GameChannel do
  require Logger
  use Phoenix.Channel

  alias ReversiBoard.{
    Playable,
    Step,
    Stones,
  }
  alias ReversiServer.{
    Game,
    RobotTask,
  }
  alias ReversiServer.Game.Supervisor, as: GameSupervisor

  def join("game:" <> game_id, _message, socket) do
    ret = GameSupervisor.create_game(game_id)
    Logger.debug("Spawned worker: " <> inspect(ret))

    player_id = socket.assigns.player_id

    case Game.join(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        Process.monitor(pid)
        {:ok, game} = Game.get_data(game_id)
        {:ok, game, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("game:add_step", %{"x" => x, "y" => y, "stone" => stone} = message, socket) do
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