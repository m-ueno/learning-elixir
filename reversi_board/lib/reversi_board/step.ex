defmodule ReversiBoard.Step do
  defstruct x: 0, y: 0, stone: 0

  def new(x, y, stone) do
    %__MODULE__{x: x, y: y, stone: stone}
  end
end