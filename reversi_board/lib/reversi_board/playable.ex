defprotocol ReversiBoard.Playable do
  alias ReversiBoard.Board

  @doc "make_step returns %Step{x, y, stone} or :skip"
  def make_step(player, board, stone)
end