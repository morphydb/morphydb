defmodule Chess.Application do
  @moduledoc false

  use Application

  @registry :room_registry
  @pubsub Chess.PubSub

  @impl true
  def start(_type, _args) do
    children = [
      ChessWeb.Telemetry,
      {Phoenix.PubSub, name: @pubsub},
      {Finch, name: Chess.Finch},
      ChessWeb.Endpoint,
      {Horde.Registry, [keys: :unique, name: @registry]},
      {Horde.DynamicSupervisor, [name: Chess.Rooms.RoomSupervisor, strategy: :one_for_one]}
    ]

    opts = [strategy: :one_for_one, name: Chess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ChessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
