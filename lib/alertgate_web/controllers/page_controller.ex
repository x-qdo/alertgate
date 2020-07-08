defmodule AlertgateWeb.PageController do
  use AlertgateWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
