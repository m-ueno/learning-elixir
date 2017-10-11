defmodule ReversiBoard.Robot do
  defstruct name: "robot"

  alias ReversiBoard.Board
  alias ReversiBoard.Cell
  alias ReversiBoard.Step

  # Returns []Cells
  defp find_flippable_cells(board = %Board{}, stone) do
    range = 0..7

    :comb.cartesian_product(range, range)
    |> Enum.filter(fn [x, y] ->
      length(Board.find_flippables(board, x, y, stone)) > 0
    end)
    |> Enum.map(fn [x, y] ->
      Cell.new(x, y)
    end)
  end

  def make_step(board = %Board{}, stone) do
    flippables = find_flippable_cells(board, stone)
    cell = Enum.at(flippables, 0)

    %Step{x: cell.x, y: cell.y, stone: stone}
  end
end