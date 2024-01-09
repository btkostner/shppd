defmodule Shppd.Repo do
  use Ecto.Repo,
    otp_app: :shppd,
    adapter: Ecto.Adapters.SQLite3
end
