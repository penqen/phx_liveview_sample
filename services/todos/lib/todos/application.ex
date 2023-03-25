defmodule TodosApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TodosAppWeb.Telemetry,
      # Start the Ecto repository
      TodosApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TodosApp.PubSub},
      # Start Finch
      {Finch, name: TodosApp.Finch},
      # Start the Endpoint (http/https)
      TodosAppWeb.Endpoint
      # Start a worker by calling: TodosApp.Worker.start_link(arg)
      # {TodosApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodosApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodosAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
