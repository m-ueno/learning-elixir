defmodule ReversiBoard.GameManager do
  alias ReversiBoard.Board
  alias ReversiBoard.Robot
  alias ReversiBoard.Stones

  def handle_console_output do
    receive do
      {:board, s} ->
        IO.write(~s(\x1b[;H))
        IO.write(s)
        handle_console_output()
      {:clear} ->
        IO.write(~s(\x1b[2J))
        handle_console_output()
      s ->
        IO.write(s)
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

  def show_update_board(board, player, color, out_handler_pid, wait \\ 100) do
    send(out_handler_pid, {:board, inspect(board)})
    :timer.sleep(wait)

    update_board(board, player, color)
  end

  def run_in_console(p1 \\ %Robot{}, p2 \\ %Robot{}) do
    init_board = Board.new
    console_output_handler = spawn(__MODULE__, :handle_console_output, [])
    send(console_output_handler, {:clear})

    Enum.zip([Stones.white, Stones.black], [p1, p2])
    |> Stream.cycle
    |> Enum.reduce_while({init_board, false}, fn {stone, player}, {board, already_skipped} ->
      board_or_skip = show_update_board(board, player, stone, console_output_handler)

      if board_or_skip == :skip do
        if already_skipped do
          {:halt, "both player skipped"}
        else
          {:cont, {board, true}}
        end
      else
        {:cont, {board_or_skip, false}}
      end
    end)
  end
end