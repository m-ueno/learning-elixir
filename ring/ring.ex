# Ring benchmark
#
# Args
#   n: Number of actors
#   m: loops
#
# Usage
#
#   elixir ring.ex 2>/dev/null
#

defmodule Util do
  def debug(obj) do
    puts(obj, :stderr)
  end

  def puts(obj, out \\ :stdio) do
    IO.puts(out, "(#{inspect self()}): #{inspect obj}")
  end
end

defmodule Ring do
  def stop do
    # terminate self
    Util.debug("stopping #{inspect self()}")

    reason = :success
    exit(reason)
  end

  def process_msg(id, neighbor, count) do
    if id == 0 do
      Util.debug "master(0): #{count}"
      if count == 0 do
        stop()
      else
        new_count = count - 1
        send(neighbor, {:msg, new_count})
      end
    else
      send(neighbor, {:msg, count})
    end
  end

  def loop(id) do
    Util.debug("#{inspect self()}: start loop1")
    receive do
      {:set_neighbor, neighbor} ->
        Util.debug("#{inspect self()}: setting neighbor")
        loop(id, neighbor)
      other -> Util.debug("should not reach here: #{inspect other}")
    end
  end

  # state
  #   neighbor
  def loop(id, neighbor) do
    receive do
      {:msg, count} ->
        process_msg(id, neighbor, count)
        loop(id, neighbor)
      {:terminate} ->
        exit(:terminated_by_msg)
      other -> Util.debug("should not reach here")
    end
  end
end

# {:msg, <count>} 形式のメッセージを送受するリングループを構築する
defmodule RingLoop do
  def make_ring(m) do
    actors = (0..m) |> Enum.map(fn i -> spawn(Ring, :loop, [i]) end)
    [head|tail] = actors
    neighbors = tail ++ [head]

    Enum.zip(actors, neighbors)
      |> Enum.each(fn elem ->
        {a, n} = elem

        Util.debug("a: #{inspect a}, n: #{inspect n}")

        send(a, {:set_neighbor, n})
        end)

    actors
  end

  def send_and_receive(n, head) do
    send(head, {:msg, n})

    Util.debug("** sent")

    receive do
      {:DOWN, _ref, :process, _from_pid, reason} ->
        Util.debug({_ref, _from_pid, reason})
        reason
      {:EXIT, head, reason} ->  # 終了を補足
        Util.debug "** #{inspect head} finished (reason: #{reason})"
        reason
    after 3 * 60 * 1000 ->
      Util.debug "** timeout #{inspect head}"
      :timeout
    end
  end

  def bench_n_m(n, m) do
    ring = make_ring(n)
    [head|tail] = ring

    # Handle life of head Actor
    # https://elixirschool.com/jp/lessons/advanced/concurrency/#%E3%83%97%E3%83%AD%E3%82%BB%E3%82%B9
    _ref = Process.monitor(head)

    # time in microseconds
    {time, reason} = :timer.tc(RingLoop, :send_and_receive, [m, head])

    Enum.each(tail, fn proc -> send(proc, {:terminate}) end)

    [n, m, Float.round(time/1000/1000, 4), reason]
  end

  def run do
    # bench()
    for i <- 5..0, j <- 0..5 do
      n = round(:math.pow(10, i))
      m = round(:math.pow(10, j))

      IO.puts(Enum.join(bench_n_m(n, m), ","))
    end
  end
end

RingLoop.run
