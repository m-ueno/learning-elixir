defmodule ReversiBoard.Robot do
  defstruct name: "robot"

  alias ReversiBoard.Board
  alias ReversiBoard.Cell
  alias ReversiBoard.Stones
  alias ReversiBoard.Step

  # Returns []Cells
  defp find_flippable_cells(board = %Board{}, stone) do
    range = 0..7

    Comb.cartesian_product(range, range)
    |> Enum.filter(fn [x, y] ->
      Board.get(board, x, y) == Stones.space
    end)
    |> Enum.filter(fn [x, y] ->
      # length(Board.find_flippables(board, x, y, stone)) > 0
      f = Board.find_flippables(board, x, y, stone)
      length(f) > 0
    end)
    |> Enum.map(fn [x, y] ->
      Cell.new(x, y)
    end)
  end

  # Returns Step or :skip
  def make_step(board = %Board{}, stone) do
    flippables = find_flippable_cells(board, stone)

    if length(flippables) > 0 do
      cell = Enum.random(flippables)
      %Step{x: cell.x, y: cell.y, stone: stone}
    else
      :skip
    end
  end
end