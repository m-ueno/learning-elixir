defmodule ReversiServer.Game do
  require Logger
  use GenServer # statefull process
  alias ReversiBoard.{Board, Robot}

  defstruct [
    id: nil,
    player1: nil,
    player2: nil,
  ]

  # alias ReversiServer.Game.{Board}

  # Client API
  ## `id` is a server state
  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def join(id, player_id, pid), do: try_call(id, {:join, player_id, pid})

  def get_data(id), do: try_call(id, :get_data)

  def add_step(id, step), do: nil

  # GenServer API
  ## init/1 callback
  def init(id) do
    # create game board / create event
    {:ok, %__MODULE__{id: id, player2: %Robot{}}}
  end

  # game is `state`
  ## handle_call/3 コールバック: {:atom, from_pid, state} -> {:reply, value, new_state}
  def handle_call({:join, player_id, pid}, _from, game) do
    Logger.debug "Handling :join for #{player_id} in Game #{game.id}"

    b = %Board{}
    game = add_player(game, %{name: player_id})

    {:reply, {:ok, self}, game}
  end

  # Generates global reference
  defp ref(id), do: {:global, {:game, id}}

  defp try_call(id, msg) do
    # returns a pid of a GenServer process
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exists"}
      game ->
        # call(server, request)
        GenServer.call(game, msg)
    end
  end

  defp add_player(%__MODULE__{player1: nil} = game, player) do
    %{game | player1: player}
  end
end
