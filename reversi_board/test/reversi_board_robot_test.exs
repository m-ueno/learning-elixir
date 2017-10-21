defmodule ReversiBoardRobotTest do
  use ExUnit.Case

  alias ReversiBoard.{
    Board,
    Playable,
    Robot,
    Step,
    Stones,
  }

  test "make_step" do
    b = Board.new
    stone = Stones.white
    assert %Step{} = Robot.make_step(b, stone)
  end

  test "should list candidate cells" do
    b = Board.new
    cells = Robot.find_flippable_cells(b, Stones.white)

    assert length(cells) == 4
  end

  test "robot should be playable" do
    b = Board.new
    assert %Step{} = Playable.make_step(%Robot{}, b, Stones.white)
  end
end
