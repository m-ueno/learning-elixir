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
    # 1st return: Broadcast an event to all subscribers of the socket topic.
    broadcast socket, "game:state", game

    # Make computer step
    step_or_skip = Playable.make_step(game.player2, game.board, Stones.black)
    if %Step{x: x, y: y, stone: stone} = step_or_skip do
      {:ok, game} = Game.add_step(game_id, x, y, stone)

      # 2nd return
      broadcast socket, "game:state", game
      {:noreply, socket}
    end
  end

  def handle_in("game:joined", _message, socket) do
    Logger.debug "Broadcasting player joined #{socket.assigns.game_id}"

    player_id = socket.assigns.player_id
    board = Board.get_opponents_data(player_id)

    broadcast! socket, "game:player_joined", %{player_id: player_id, board: board}
    {:noreply, socket}
  end

end