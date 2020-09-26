defmodule Alertgate.Publisher do
  @moduledoc false

  use GenServer

  alias Alertgate.UnifiedAlertMessage

  ## Client API

  def start_link(_default) do
    GenServer.start_link(__MODULE__, :ok, name: :publisher)
  end

  def publish(%UnifiedAlertMessage{} = alert) do
    {:ok, message} = Poison.encode(alert)
    GenServer.cast(:publisher, {:publish, message})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Exchange.declare(channel, "alerts", :topic, [durable: true, auto_delete: false])
    AMQP.Queue.declare(channel, "alerts", [durable: true, auto_delete: true])
    {:ok, %{channel: channel, connection: connection}}
  end

  def handle_cast({:publish, message}, state) do
    IO.puts "handling cast.. "
    AMQP.Basic.publish(state.channel, "alerts", "alerts", message, [content_type: "application/json"])
    {:noreply, state}
  end

  def terminate(_reason, state) do
    AMQP.Connection.close(state.connection)
  end
end