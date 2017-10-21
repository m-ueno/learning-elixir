defmodule ReversiServer.Game do
  require Logger
  use GenServer # statefull process
  alias ReversiBoard.{
    Board,
    Robot,
    Step,
    Stones,
  }
  alias ReversiServer.RobotTask

  defstruct [
    id: nil,
    turn: Stones.white,
    player1: nil,
    player2: nil,
    board: nil,
    already_skipped: false,
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

  # game is `state`
  ## handle_call/3 コールバック: {:atom, from_pid, state} -> {:reply, value, new_state}
  def handle_call({:join, player_id, pid}, _from, game) do
    Logger.debug "Handling :join for #{player_id} in Game #{game.id}"

    b = %Board{}
    game = add_player(game, %{name: player_id})

    {:reply, {:ok, self}, game}
  end

  def handle_call(:get_data, _from, game) do
    {:reply, {:ok, game}, game}
  end

  def handle_call({:add_step, %Step{} = step}, _from, game) do
    { new_board_or_skip, new_turn } =
      if step.stone == :skip do
        {
          :skip,
          game.turn,
        }
      else
        {
          Board.set_and_flip(game.board, step),
          step.stone,
        }
      end

    # update state (or not when skipped)
    game = case new_board_or_skip do
      :skip -> game
      %Board{} -> %{game | board: new_board_or_skip, turn: new_turn}
    end

    {:reply, {:ok, game}, game}
  end

  # Generates global reference
  def ref(id), do: {:global, {:game, id}}

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
