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
end
