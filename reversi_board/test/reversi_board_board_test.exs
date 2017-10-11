defmodule ReversiBoardBoardTest do
  use ExUnit.Case
  # doctest ReversiBoard

  alias ReversiBoard.Board
  alias ReversiBoard.Stones

  test "new board" do
    b = Board.new
    assert length(Enum.filter(b.board, fn e -> e == Stones.white end)) == 2
    assert length(Enum.filter(b.board, fn e -> e == Stones.black end)) == 2
  end

  test "find flippables with initial board" do
    b = Board.new

    assert [] == Board.find_flippables(b, 3, 2, Stones.white)
    refute [] == Board.find_flippables(b, 3, 2, Stones.black)

    assert [] == Board.find_flippables(b, 4, 2, Stones.black)
    refute [] == Board.find_flippables(b, 4, 2, Stones.white)
  end
end
