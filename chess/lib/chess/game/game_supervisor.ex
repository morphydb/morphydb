defmodule Game.GameSupervisor do
  alias Game.GameServer

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child({name, fen}) do
    DynamicSupervisor.start_child(__MODULE__, {GameServer, {name, fen}})
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
