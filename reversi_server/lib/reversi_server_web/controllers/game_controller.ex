defmodule ReversiServerWeb.GameController do
  use ReversiServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
