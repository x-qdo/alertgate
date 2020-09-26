defmodule Alertgate.AlertProcessor do
  @moduledoc """
  The AlertProcessor context.
  """
  require Logger
  alias Alertgate.UnifiedAlertMessage
  alias Alertgate.Publisher

  def dispatch(source, payload) do
    try do
      source
      |> make_unified_alert(payload)
      |> Publisher.publish
      {:ok, "#{source} alert will be processed"}
    catch
      e -> {:error, e}
    end
  end

  defp make_unified_alert("prometheus", payload) do
    Logger.info "Hello Prometheus!"
    {:ok, datetime} = DateTime.now("Etc/UTC")
    opt = %{
      source: "prometheus",
      createdAt: DateTime.to_string(datetime),
      status: payload["status"],
      description: payload["commonAnnotations"]["description"],
      payload: payload
    }
    struct(UnifiedAlertMessage, opt)
  end

  defp make_unified_alert(source, _payload) do
    Logger.error "Alert Processor can't recognize source #{source}"
    throw "Alert Processor can't recognize source #{source}"
  end
end

