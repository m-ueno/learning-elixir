defmodule ReversiServerWeb.AdminChannel do
  require Logger
  use Phoenix.Channel

  alias ReversiServer.{
    Game,
  }
  alias ReversiServer.Game.Supervisor, as: GameSupervisor

  def join("admin:monitor", _message, socket) do
    _player_id = socket.assigns.player_id

    send(self(), :after_join)

    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # push socket, "feed", %{list: feed_items(socket)}
    # {:noreply, socket}
    pid = spawn_link fn -> push_state_loop(socket) end
    Logger.debug("Spawned loop:" <> inspect(pid))
    {:noreply, socket}
  end

  def all_game_state do
    GameSupervisor.children_id
    |> Enum.map(fn game_id -> Game.get_data(game_id) end)
    |> Enum.map(fn {:ok, game} -> game end)
  end

  def push_state_loop(socket) do
    push socket, "all_game_state", %{games: all_game_state()}
    :timer.sleep(2000)
    push_state_loop(socket)
  end

  def terminate(_reason, _socket) do
    :ok
  end
end