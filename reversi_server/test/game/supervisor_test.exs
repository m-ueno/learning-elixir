defmodule ReversiServerWeb.Game.SupervisorTest do
  # use ReversiServerWeb.ConnCase
  use ExUnit.Case

  alias ReversiServer.Game.Supervisor, as: GameSupervisor

  setup_all do
    GameSupervisor.create_game("game1")
    GameSupervisor.create_game("game2")
    :ok
  end

  test "has 2 children" do
    children = GameSupervisor.children
    assert length(children) == 2

    g = Enum.at(children, 0)
    assert is_pid(g)
  end

  test "children id" do
    child_ids = GameSupervisor.children_id

    assert child_ids == ["game1", "game2"]
  end
end
