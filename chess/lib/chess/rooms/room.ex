defmodule Chess.Rooms.Room do
  use GenServer

  alias __MODULE__
  import Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.LoadFen
  alias Chess.GamePubSub
  alias Chess.Games.Game

  require Logger

  @registry :room_registry
  @supervisor Chess.Rooms.RoomSupervisor

  # API

  def start_link(room_id), do: GenServer.start_link(Room, room_id, name: via_tuple(room_id))

  def exists?(room_id) do
    case Horde.Registry.lookup(@registry, room_id) do
      [{_pid, _}] -> true
      _ -> false
    end
  end

  def create_room(room_id) do
    child_spec = Room.child_spec(room_id)

    Horde.DynamicSupervisor.start_child(@supervisor, child_spec)
  end

  def close(room_id),
    do:
      room_id
      |> via_tuple()
      |> GenServer.stop()

  def current_events(room_id),
    do:
      room_id
      |> via_tuple()
      |> GenServer.call({:get_events})

  def dispatch(room_id, command),
    do:
      room_id
      |> via_tuple()
      |> GenServer.cast({:dispatch, command})

  # Server

  @impl GenServer
  def init(room_id) do
    {:ok,
     %{room_id: room_id, events: []}
     |> dispatch_command(%LoadFen{fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"})}
  end

  def child_spec(room_id) do
    %{
      id: "Room_#{room_id}",
      start: {Room, :start_link, [room_id]},
      restart: :transient
    }
  end

  @impl GenServer
  def handle_call({:get_events}, _from, state),
    do:
      state
      |> reply_call(state.events)

  @impl GenServer
  def handle_cast({:dispatch, command}, state),
    do:
      state
      |> dispatch_command(command)
      |> reply_cast()

  defp dispatch_command(state, command),
    do:
      state.events
      |> Game.build_state()
      |> log_command(command)
      |> (fn state -> handle_command(command, state) end).()
      |> log_events()
      |> dispatch_events(state.room_id)
      |> build_new_state(state)

  defp log_command(state, command) do
    Logger.info("Dispatching command #{inspect(command)} on state #{inspect(state)}")
    state
  end

  defp log_events(events) do
    IO.puts("************** EVENTS **************")
    for event <- events, do: IO.puts("Event #{inspect(event)}")
    IO.puts("************** /EVENTS **************")

    events
  end

  defp dispatch_events(events, room_id) do
    # for event <- events, do: GamePubSub.publish(room_id, event)
    GamePubSub.publish(room_id, [events] |> List.flatten())

    events
  end

  defp build_new_state(events, state), do: %{state | events: state.events ++ events}

  defp reply_call(state, result), do: {:reply, result, state}
  defp reply_cast(state), do: {:noreply, state}

  defp via_tuple(room_id), do: {:via, Horde.Registry, {@registry, room_id}}
end
