defmodule ReversiBoard.Robot do
  defstruct name: "robot"

  alias ReversiBoard.Board
  alias ReversiBoard.Cell
  alias ReversiBoard.Stones
  alias ReversiBoard.Step

  # Returns []Cells
  defp find_flippable_cells(%Board{} = board, stone) do
    range = 0..7

    for x <- range, y <- range do
      [x, y]
    end
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
  def make_step(%Board{} = board, stone) do
    flippables = find_flippable_cells(board, stone)

    if length(flippables) > 0 do
      cell = Enum.random(flippables)
      %Step{x: cell.x, y: cell.y, stone: stone}
    else
      :skip
    end
  end
end

defimpl ReversiBoard.Playable, for: ReversiBoard.Robot do
  alias ReversiBoard.Robot

  def make_step(%Robot{}, board, stone) do
    Robot.make_step(board, stone)
  end
end