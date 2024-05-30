defmodule Xcrapper.Repo do
  use Ecto.Repo,
    otp_app: :xcrapper,
    adapter: Ecto.Adapters.Postgres
end
