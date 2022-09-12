defmodule Game.GameServer do
  alias Game.Parsers.FenParser
  alias Game.Position

  use GenServer

  @name __MODULE__

  def start_link({name, fen}) do
    {:ok, pid} = GenServer.start_link(@name, fen, name: name)

    pid
  end

  def child_spec(name) do
    %{
      id: @name,
      start: {@name, :start_link, [name]},
      restart: :transient
    }
  end

  def stop(name, stop_reason) do
    GenServer.stop(name, stop_reason)
  end

  @impl true
  def init(fen) do
    {:ok, FenParser.parse!(fen)}
  end

  @impl true
  def handle_call(:get_position, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:highlight, square_index, modifier}, state) do
    {:noreply, state |> Position.highlight(square_index, modifier)}
  end

  @impl true
  def handle_cast(:clear, state) do
    {:noreply, state |> Position.clear_highlights()}
  end

  @impl true
  def handle_cast({:arrow, from, to}, state) do
    {:noreply, Position.arrow(state, %{from: from, to: to})}
  end
end
