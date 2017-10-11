defmodule ReversiBoard.GameManager do
  alias ReversiBoard.Board
  alias ReversiBoard.Robot
  alias ReversiBoard.Stones

  def update_board(board, player, color) do
    step = Robot.make_step(board, color)
    if step == :skip do
      :skip
    else
      Board.update(board, step)
    end
  end

  def run(p1 \\ %Robot{}, p2 \\ %Robot{}) do
    init_board = Board.new

    last_board = 1..40
    |> Enum.reduce_while(init_board, fn i, board ->
      board_or_skip1 = update_board(board, p1, Stones.white)
      board_or_skip2 = update_board(board_or_skip1, p1, Stones.white)
      if board_or_skip1 == :skip && board_or_skip2 == :skip do
        {:halt, "both player skipped"}
      else
        {:cont, board_or_skip2}
      end
    end)
  end
end