defmodule ReversiBoard.Board do
  defstruct board: [], steps: []

  # `, as...` は省略可能
  alias ReversiBoard.Step, as: Step
  alias ReversiBoard.Stones, as: Stones

  def new() do
    initial_board = []
    __MODULE__.new(initial_board)
  end

  def new(board) do
    %__MODULE__{board: board}
  end

  def turn_over(board, x, y, color) do
    Enum.zip([-1..1, -1..1])
    |> Enum.filter(fn e -> e == [0, 0] end)
    |> Enum.map(fn e ->
      [dx, dy] = e
      turn_over_dx_dy(board, x, y, color, dx, dy, [])
    end)
  end

  defp turn_over_dx_dy(board, x, y, color, dx, dy, candidates) do
    opponent = Hands.opponent(color)

    case get(board, x, y) do
      @s -> []
      color -> candidates
      opponent ->
        nx = x + dx
        ny = y + dy
        turn_over_dx_dy(board, nx, ny, color, dx, dy, candidates ++ [x, y])
    end
  end

  def get(board, x, y) do
    Enum.at(Enum.at(board.board, y), x)
  end

  def set(board, x, y, color) do
    new_board = List.update_at(
      board.board,
      y,
      fn inner ->
        List.update_at(
          inner,
          x,
          fn _ -> color end)
      end)
    new(new_board)
  end
end