defmodule ReversiBoard.Board do
  defstruct board: [], steps: []

  # `, as...` は省略可能
  alias ReversiBoard.Board, as: Board
  alias ReversiBoard.Step, as: Step
  alias ReversiBoard.Stones, as: Stones

  def new() do
    board = new(List.duplicate(Stones.space, 8 * 8))
    board = set(board, 3, 3, Stones.white)
    board = set(board, 4, 4, Stones.white)
    board = set(board, 3, 4, Stones.black)
    board = set(board, 4, 3, Stones.black)
    board
  end

  def new(board) do
    %__MODULE__{board: board}
  end

  def find_flippables(%Board{} = board, x, y, color) do
    for dx <- -1..1, dy <- -1..1 do
      if {dx, dy} == {0, 0} do
        []
      else
        find_flippables_dx_dy(board, x+dx, y+dy, color, dx, dy)
      end
    end
    |> List.foldr([], fn x, acc -> acc ++ x end)
  end

  # Returns []Cell, not including the first stone
  def find_flippables_dx_dy(%Board{} = board, x, y, color, dx, dy, acc \\ []) do
    {nx, ny} = {x+dx, y+dy}

    cond do
      ! is_valid_pos(x, y) -> []
      get(board, x, y) == Stones.space -> []
      get(board, x, y) == color -> acc
      true ->
        # Continue if opponent's color
        find_flippables_dx_dy(board, nx, ny, color, dx, dy, acc ++ [[x, y]])
    end
  end

  def is_valid_pos(x, y) do
    0 <= x && x < 8 && 0 <= y && y < 8
  end

  def get(%Board{board: board}, x, y) do
    Enum.at(board, x + y * 8)
  end

  def set(%Board{} = board, x, y, color) do
    stones = List.update_at(board.board, x + y * 8, fn _ -> color end)
    new(stones)
  end

  def set_and_flip(%Board{} = board, %Step{x: x, y: y, stone: stone} = step) do
    new_b = set(board, x, y, stone)

    find_flippables(board, x, y, stone)
    |> Enum.reduce(new_b, fn [x, y], acc ->
      set(acc, x, y, step.stone)
    end)
  end
end

defimpl Inspect, for: ReversiBoard.Board do
  alias ReversiBoard.Board

  def inspect(%Board{} = board, _opts) do
    stones = board.board  # 1d array
    _steps = board.steps

    s = stones
    |> Enum.chunk(8)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")

    s <> "\n\n"
  end
end
