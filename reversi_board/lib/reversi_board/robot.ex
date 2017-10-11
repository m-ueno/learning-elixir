defmodule ReversiBoard.Robot do
  defstruct name: "robot"

  alias ReversiBoard.Board
  alias ReversiBoard.Step

  def make_step(board = %Board{}, color) do
    flippables = Board.find_flippables(board, color)
    cell = Enum.at(flippables, 0)

    %Step{x: cell.x, y: cell.y, color: color}
  end
end