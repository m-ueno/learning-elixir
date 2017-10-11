defmodule ReversiBoard.GameManager do
  alias ReversiBoard.Board
  alias ReversiBoard.Robot
  alias ReversiBoard.Stones

  def update_board(board, _player,  color) do

    IO.inspect(board)

    step = Robot.make_step(board, color)
    if step == :skip do
      :skip
    else
      Board.set_and_flip(board, step)
    end
  end

  def run(p1 \\ %Robot{}, p2 \\ %Robot{}) do
    init_board = Board.new

    last_board = 1..40
    |> Enum.reduce_while(init_board, fn _, board ->
      board_or_skip1 = update_board(board, p1, Stones.white)
      board_or_skip2 = update_board(board_or_skip1, p2, Stones.black)
      if board_or_skip1 == :skip && board_or_skip2 == :skip do
        {:halt, "both player skipped"}
      else
        {:cont, board_or_skip2}
      end
    end)

    IO.inspect(last_board)
  end
end