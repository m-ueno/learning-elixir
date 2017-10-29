defmodule ReversiServer.Game do
  @moduledoc """
  Game is a stateful process supervised by `ReversiServer.Game.Supervisor`.
  """
  require Logger
  use GenServer
  alias ReversiBoard.{
    Board,
    Robot,
    Step,
    Stones,
  }

  defstruct [
    id: nil,
    turn: Stones.white,
    player1: nil,
    player2: nil,
    board: nil,
    already_skipped: false,
    game_is_over: false,
  ]

  # Client API
  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def join(id, player_id, pid), do: try_call(id, {:join, player_id, pid})

  def get_data(id), do: try_call(id, :get_data)

  def add_step(id, x, y, stone) do
    step = %Step{x: x, y: y, stone: stone}
    try_call(id, {:add_step, step})
  end

  # GenServer API
  def init(id) do
    {:ok, %__MODULE__{id: id, board: Board.new, player2: %Robot{}}}
  end

  # handle_call/3 callback
  # receive {:atom, from_pid, state} and
  # return  {:reply, value, new_state}
  def handle_call({:join, player_id, _pid}, _from, game) do
    Logger.debug "Handling :join for #{player_id} in Game #{game.id}"

    game = add_player(game, %{name: player_id})

    {:reply, {:ok, self()}, game}
  end

  def handle_call(:get_data, _from, game) do
    {:reply, {:ok, game}, game}
  end

  def handle_call({:add_step, %Step{} = step}, _from, game) do
    {
      new_board,
      new_turn,
      already_skipped,
      game_is_over,
    } = if step.stone == :skip do
      over = if game.already_skipped, do: true, else: false
      {
        game.board,
        game.turn,
        true,
        over
      }
    else
      next_turn = if game.turn == Stones.white, do: Stones.black, else: Stones.white
      {
        Board.set_and_flip(game.board, step),
        next_turn,
        false,
        false,
      }
    end

    game = %{game |
      board: new_board,
      turn: new_turn,
      already_skipped: already_skipped,
      game_is_over: game_is_over,
    }

    {:reply, {:ok, game}, game}
  end

  # Generates global reference
  def ref(id), do: {:global, {:game, id}}

  # Search process with given id and call given msg
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

  defp add_player(%__MODULE__{} = game, player) do
    %{game | player1: player}
  end
end
