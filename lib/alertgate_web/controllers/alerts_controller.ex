defmodule AlertgateWeb.AlertsController do
  use AlertgateWeb, :controller

  alias Alertgate.AlertProcessor

  def create(conn, %{"source" => source} = params) do
    AlertProcessor.dispatch(source, params)
    |> handle_response(conn)
  end

  defp handle_response({:ok, message}, conn) do
    conn
    |> send_resp(200, message)
  end

  defp handle_response({:error, message}, conn) do
    conn
    |> send_resp(501, message)
  end

end
