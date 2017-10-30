defmodule ReversiServerWeb.Channels.GameChannelTest do
  use ReversiServerWeb.ChannelCase

  alias ReversiServerWeb.GameChannel
  alias ReversiServer.Game.Supervisor, as: GameSupervisor
  alias ReversiServer.Game
  alias ReversiBoard.Stones

  @doc """
  game_channel:join does too many things.
  * spawn child via supervisor with gameid
  * Game.join(game_id)
  * return

  Its difficult to test join because it spawn child.
  to test, destroy childs?

  After test, supervisor is still running, games are still alive.

  How to test GenServer?
  """
  # setup do
  #   game_id = "channel_test_01"
  #   {:ok, _, socket} =
  #     socket("player_id", %{player_id: 999})
  #     |> subscribe_and_join(GameChannel, "game:" <> game_id, %{})

  #   on_exit(make_ref(), fn ->
  #     IO.puts("******:: onexit on game channel test ********::")
  #     GameSupervisor.destory_game(game_id)
  #     assert GameSupervisor.children.length == 0
  #   end)
  #   {:ok, socket: socket}
  # end

  test "handle add_step" do
    game_id = "channel_test_01"
    assert {:ok, reply, socket} =
      socket("player_id", %{player_id: 999})
      |> subscribe_and_join(GameChannel, "game:" <> game_id, %{})

    assert reply

    ref = push(socket, "game:add_step", %{"x" => 1, "y" => 1, "stone"=> Stones.white})

    # assert_broadcast(event, payload, timeout \\ 100)
    assert_broadcast "game:state", %ReversiServer.Game{}
    # assert_reply(ref, status, payload \\ Macro.escape(%{}), timeout \\ 100)
    assert_broadcast "game:state", %ReversiServer.Game{}, 550

    # async close
    # ref = leave(socket)
    # assert ref, :ok

    # close is always sync and it will return only after the channel process is guaranteed to have been terminated
    :ok = close(socket)
  end

end
