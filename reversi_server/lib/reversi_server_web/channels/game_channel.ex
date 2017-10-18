defmodule ReversiServerWeb.GameChannel do
  require Logger
  use Phoenix.Channel

  alias ReversiBoard.{
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
        {:ok, game_state} = Game.get_data(game_id)
        {:ok, game_state, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("game:add_step", %{x: x, y: y, stone: stone} = message, socket) do
    case Game.add_step(socket.game_id, x, y, stone) do
      {:ok, new_board_or_skip} ->
        # Broadcast an event to all subscribers of the socket topic.
        broadcast socket, "game:update", %{board: new_board_or_skip}
        {:ok, %{board: new_board_or_skip}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
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