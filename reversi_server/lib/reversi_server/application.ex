defmodule ReversiServer.Application do
  @moduledoc """
  Application root.
  """
  @id_length Application.get_env(:reversi_server, :id_length)

  use Application
  alias ReversiServerWeb.Endpoint

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ReversiServer.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ReversiServerWeb.Endpoint, []),
      supervisor(ReversiServer.Game.Supervisor, []),
      # Start your own worker by calling: ReversiServer.Worker.start_link(arg1, arg2, arg3)
      # worker(ReversiServer.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReversiServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end

  @doc """
  Generates unique id for the game
  https://github.com/bigardone/phoenix-battleship/blob/master/lib/battleship.ex
  """
  def generate_player_id do
    @id_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end
end
