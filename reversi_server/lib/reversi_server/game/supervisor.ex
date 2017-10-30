defmodule ReversiServer.Game.Supervisor do
  @moduledoc """
  Game processes supervisor
  """
  require Logger

  use Supervisor
  alias ReversiServer.{Game}

  def start_link, do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    children = [
      worker(Game, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Creates a new supervised Game process
  """
  def create_game(id) do
    Logger.debug("Game.Supervisor -- creating: " <> id)
    Supervisor.start_child(__MODULE__, [id])
  end

  def destroy_game(id) do
    pid = GenServer.whereis(Game.ref(id))
    Supervisor.terminate_child(__MODULE__, pid)
  end

  def children do
    pids = Supervisor.which_children(__MODULE__)

    pids
    |> Enum.map(fn {_, child, _, _} -> child end)
  end

  def children_id do
    pids = children()
    |> Enum.map(fn pid -> GenServer.call(pid, :get_data) end)
    |> Enum.map(fn {:ok, obj} -> obj.id end)
  end
end
