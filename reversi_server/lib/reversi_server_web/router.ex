defmodule ReversiServerWeb.Router do
  use ReversiServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReversiServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/game", GameController, :index
  end

  defp put_user_token(conn, _) do
    generated_player_id = ReversiServer.Application.generate_player_id
    assign(conn, :player_id, generated_player_id)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReversiServerWeb do
  #   pipe_through :api
  # end
end
