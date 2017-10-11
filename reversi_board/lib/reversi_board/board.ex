defmodule ReversiBoard.Board do
  @size 8
  def size, do: @size

  defstruct board: [], steps: []

  # `, as...` は省略可能
  alias ReversiBoard.Board, as: Board
  alias ReversiBoard.Step, as: Step
  alias ReversiBoard.Stones, as: Stones

  def new() do
    board = new(List.duplicate(Stones.space, @size * @size))
    board = set(board, 3, 3, Stones.white)
    board = set(board, 4, 4, Stones.white)
    board = set(board, 3, 4, Stones.black)
    board = set(board, 4, 3, Stones.black)
    board
  end

  def new(board) do
    %__MODULE__{board: board}
  end

  def find_flippables(board = %Board{}, x, y, color) do
    Comb.cartesian_product(-1..1, -1..1)
    |> Enum.flat_map(fn [dx, dy] ->
      if {dx, dy} == {0, 0} do
        []
      else
        find_flippables_dx_dy(board, x+dx, y+dy, color, dx, dy)
      end
    end)
  end

  # Returns []Cell, not including the first stone
  def find_flippables_dx_dy(board = %Board{}, x, y, color, dx, dy, acc \\ []) do
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
    Enum.at(board, x + y * @size)
  end

  def set(board = %Board{}, x, y, color) do
    stones = List.update_at(board.board, x + y*@size, fn _ -> color end)
    new(stones)
  end

  def set_and_flip(board = %Board{}, step = %Step{x: x, y: y, stone: stone}) do
    new_b = set(board, x, y, stone)

    find_flippables(board, x, y, stone)
    |> Enum.reduce(new_b, fn [x, y], acc ->
      set(acc, x, y, step.stone)
    end)
  end
end

defimpl Inspect, for: ReversiBoard.Board do
  alias ReversiBoard.Board

  def inspect(board = %Board{}, _opts) do
    stones = board.board  # 1d array
    _steps = board.steps

    s = stones
    |> Enum.chunk(8)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")

    s <> "\n\n"
  end
end