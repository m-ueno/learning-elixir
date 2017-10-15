defmodule ReversiServerWeb.GameChannel do
  require Logger
  use Phoenix.Channel

  alias ReversiServer.Game

  def join("game:" <> game_id, _message, socket) do
    Logger.debug "Joining Game channel #{game_id}", game_id: game_id

    player_id = socket.assigns.player_id

    case Game.join(game_id, player_id, socket.channel_pid) do
      {:ok, pid} ->
        Process.monitor(pid)
        {:ok, assign(socket, :game_id, game_id)}
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