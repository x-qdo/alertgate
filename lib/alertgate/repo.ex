defmodule Alertgate.Repo do
  use Ecto.Repo,
    otp_app: :alertgate,
    adapter: Ecto.Adapters.Postgres
end
