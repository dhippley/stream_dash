defmodule StreamDash.Repo do
  use Ecto.Repo,
    otp_app: :stream_dash,
    adapter: Ecto.Adapters.Postgres
end
