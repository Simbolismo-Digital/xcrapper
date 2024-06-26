defmodule Xcrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      XcrapperWeb.Telemetry,
      # Start the Ecto repository
      Xcrapper.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Xcrapper.PubSub},
      # Start Finch
      {Finch, name: Xcrapper.Finch},
      # Start the Endpoint (http/https)
      XcrapperWeb.Endpoint,
      # Scrapper server
      Xcrapper.Scrapper.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Xcrapper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XcrapperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
