defmodule Alertgate.UnifiedAlertMessage do
  defstruct source: nil,
            createdAt: "",
            status: "",
            description: "",
            payload: %{}
end
