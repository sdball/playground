defmodule PlaygroundWeb.HelloController do
  use PlaygroundWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
