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
    board = set(board, 3, 4, Stones.white)
    board
  end

  def new(board) do
    %__MODULE__{board: board}
  end

  def find_flippables(board, x, y, color) do
    :comb.cartesian_product(-1..1, -1..1)
    |> Enum.flat_map(fn [dx, dy] ->
      find_flippables_dx_dy(board, x, y, color, dx, dy)
    end)
  end

  # Returns []Cell, not including the first stone
  def find_flippables_dx_dy(board, x, y, color, dx, dy, acc \\ []) do
    cond do
      ! is_valid_pos(x, y) -> []
      get(board, x, y) == Stones.space -> []
      get(board, x, y) == color -> acc
      true ->
        # Continue if opponent's color
        acc = acc ++ [x, y]
        find_flippables_dx_dy(board, x+dx, y+dy, color, dx, dy, acc)
    end
  end

  def is_valid_pos(x, y) do
    0 <= x && x < 8 && 0 <= y && y < 8
  end

  def get(board, x, y) do
    Enum.at(board.board, x + y * @size)
  end

  def set(board = %Board{}, x, y, color) do
    stones = List.update_at(board.board, x + y*@size, fn _ -> color end)
    new(stones)
  end

  def set_and_flip(board = %Board{}, step = %Step{x: x, y: y, stone: stone}) do
    new_b = set(board, x, y, stone)

    flippables = find_flippables(board, x, y, stone)

    flipped_board = flippables
      |> Enum.reduce(new_b, fn [x, y], acc ->
        set(acc, x, y, step.stone)
      end)

    new(flipped_board)
  end
end