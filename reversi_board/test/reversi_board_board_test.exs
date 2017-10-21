defmodule ReversiBoardBoardTest do
  use ExUnit.Case
  # doctest ReversiBoard

  alias ReversiBoard.Board
  alias ReversiBoard.Step
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

  test "get" do
    b = Board.new
    assert Stones.white == Board.get(b, 3, 3)
    assert Stones.white == Board.get(b, 4, 4)
  end

  test "set" do
    b = Board.new
    b = Board.set(b, 3, 2, Stones.black)
    assert Stones.black == Board.get(b, 3, 2)
  end

  test "set and flip" do
    b = Board.new
    s = Step.new(3, 2, Stones.black)

    new_board = Board.set_and_flip(b, s)
    assert Board.get(new_board, 3, 2) == Stones.black
    assert Board.get(new_board, 3, 3) == Stones.black
    assert Board.get(new_board, 3, 4) == Stones.black
  end

  test "inspect returns multiline string" do
    s = inspect(Board.new)
    assert length(String.split(s, "\n")) == 10
  end
end
