defmodule ReversiServer.RobotTask do
  @moduledoc "memo: keep stateless, use Task, don't GenServer"

  alias ReversiBoard.{
    Board,
    Robot,
    Step,
    Stones,
  }

  def start(game_id, stone) do
    ReversiServerWeb.Endpoint.subscribe("game:add_step") # game_id全部サブスクライブしてしまう

    loop
  end

  def loop do
    receive do
      obj ->
        IO.inspect({"lonely robot:", obj})
        loop
    end
  end

  def make_step(board, stone) do
    Robot.make_step(board, stone)
  end
end