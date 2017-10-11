defmodule ReversiBoard.Cell do
  defstruct x: 0, y: 0

  def new(x, y) do
    %__MODULE__{x: x, y: y}
  end
end