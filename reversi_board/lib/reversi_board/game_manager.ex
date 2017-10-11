defmodule ReversiBoard.GameManager do
  alias ReversiBoard.Board
  alias ReversiBoard.Robot
  alias ReversiBoard.Stones

  def handle_console_output do
    receive do
      s -> IO.write(s)
      handle_console_output()
    end
  end

  def update_board(board, _player,  color) do
    step = Robot.make_step(board, color)
    if step == :skip do
      :skip
    else
      Board.set_and_flip(board, step)
    end
  end

  def show_update_board(board, player, color, out_handler_pid) do
    send(out_handler_pid, inspect(board))

    update_board(board, player, color)
  end

  def run_in_console(p1 \\ %Robot{}, p2 \\ %Robot{}) do
    init_board = Board.new
    console_output_handler = spawn(__MODULE__, :handle_console_output, [])

    last_board = Stream.iterate(1, fn e -> e + 1 end)  # infinite loop
    |> Enum.reduce_while(init_board, fn _, board ->
      board_or_skip1 = show_update_board(board, p1, Stones.white, console_output_handler)
      board_or_skip2 = show_update_board(board_or_skip1, p2, Stones.black, console_output_handler)
      if board_or_skip1 == :skip && board_or_skip2 == :skip do
        {:halt, "both player skipped"}
      else
        {:cont, board_or_skip2}
      end
    end)

    IO.inspect(last_board)
  end
end