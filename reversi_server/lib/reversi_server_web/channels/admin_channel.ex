defmodule ReversiServerWeb.AdminChannel do
  @moduledoc """
  Channel for admin.
  """
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

  @doc """
  Spawn a loop process
  """
  def handle_info(:after_join, socket) do
    pid = spawn_link fn -> push_state_loop(socket) end

    Logger.debug("Spawned loop:" <> inspect(pid))

    {:noreply, socket}
  end

  @doc """
  List all state of child of gamesupervisor
  """
  def all_game_state do
    GameSupervisor.children_id
    |> Enum.map(fn game_id -> Game.get_data(game_id) end)
    |> Enum.map(fn {:ok, game} -> game end)
  end

  @doc """
  Push games state to given socket if state changed
  """
  def push_state_loop(socket, prev_state \\ %{games: nil}) do
    state = all_game_state()

    if state != prev_state do
      push socket, "all_game_state", %{games: all_game_state()}
    end

    :timer.sleep(2000)
    push_state_loop(socket, state)
  end

  @doc "TBD"
  def terminate(_reason, _socket) do
    :ok
  end
end