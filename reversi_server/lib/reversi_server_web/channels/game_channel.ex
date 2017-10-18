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
    Logger.debug "Joining Game channel #{game_id}", game_id: game_id

    ret = GameSupervisor.create_game(game_id)
    Logger.debug("supervised: " <> ret)

    player_id = socket.assigns.player_id

    case Game.join(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        Process.monitor(pid)
        {:ok, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  @doc "Start Game worker via GameSupervisor"
  def handle_in("game:start", _message, socket) do
    Logger.debug("Starting new game", game_id: socket.game_id)

    case Game.start do
      {:ok, board} ->
        {:ok, %{board: board}, socket}
      other ->
        IO.inspect(other)
        {:error, %{reason: other}}
    end
  end

  def handle_in("game:add_step", %{x: x, y: y, stone: stone} = message, socket) do
    Logger.debug("socket: ", inspect(socket))

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