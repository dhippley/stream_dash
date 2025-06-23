defmodule StreamDash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StreamDashWeb.Telemetry,
      # Commented out Repo since we don't need database for this demo
      # StreamDash.Repo,
      {DNSCluster, query: Application.get_env(:stream_dash, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: StreamDash.PubSub},
      # Start the data stream producer
      StreamDash.DataStream,
      # Start the Finch HTTP client for sending emails
      {Finch, name: StreamDash.Finch},
      # Start a worker by calling: StreamDash.Worker.start_link(arg)
      # {StreamDash.Worker, arg},
      # Start to serve requests, typically the last entry
      StreamDashWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StreamDash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamDashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
