defmodule ReversiServerWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> room_id, _message, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end
end