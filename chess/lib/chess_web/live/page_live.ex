defmodule ChessWeb.PageLive do
  use ChessWeb, :live_view

  alias Chess.Games.Events.ArrowRemoved
  alias Chess.Games.Events.ArrowAdded
  alias Chess.Games.Events.SquareHighlighted
  alias Chess.Games.Events.SquareSelected
  alias Chess.Games.Events.SquareDeselected
  alias Chess.Games.FenParser
  alias Chess.Games.Events.FenLoaded
  alias Chess.GamePubSub
  alias Phoenix.LiveView
  alias Chess.Rooms.Room
  alias ChessWeb.Components.GameComponent

  @impl LiveView
  def mount(%{"room_id" => room_id}, _session, socket) do
    case Room.exists?(room_id) do
      false ->
        {:ok, push_redirect(socket, to: ~p(/))}

      true ->
        if connected?(socket), do: GamePubSub.subscribe(room_id)

        {:ok,
         socket
         |> assign(
           %{
             room_id: room_id,
             fen: nil,
             position: [],
             arrows: [],
             selected_square: nil,
             highlighted_squares: %{}
           }
           |> set_state(Room.current_events(room_id))
         )}
    end
  end

  @impl LiveView
  def mount(_params, _session, socket) do
    room_id = Nanoid.generate()
    Room.create_room(room_id)

    {:ok, push_redirect(socket, to: ~p(/#{room_id}))}
  end

  @impl LiveView
  def render(assigns) do
    ~H"""
    <.live_component
      module={GameComponent}
      id="game"
      room_id={@room_id}
      fen={@fen}
      position={@position}
      arrows={@arrows}
      selected_square={@selected_square}
      highlighted_squares={@highlighted_squares}
    />
    """
  end

  @impl LiveView
  def handle_info([], socket), do: {:noreply, socket}

  @impl LiveView
  def handle_info([event], socket) do
    state =
      apply_event(event, socket.assigns)
      |> clean_assigns()

    {:noreply, socket |> assign(state)}
  end

  @impl LiveView
  def handle_info([event | events], socket) do
    {:noreply, socket} = handle_info([event], socket)
    handle_info(events, socket)
  end

  defp clean_assigns(assigns) do
    {_, clean_assigns} = Map.pop!(assigns, :flash)
    clean_assigns
  end

  defp set_state(state, events),
    do: Enum.reduce(events, state, fn e, state -> apply_event(e, state) end)

  defp apply_event(%ArrowAdded{} = event, state),
    do: %{state | arrows: [Map.from_struct(event) | state.arrows]}

  defp apply_event(%ArrowRemoved{} = event, state),
    do: %{
      state
      | arrows: Enum.reject(state.arrows, fn arrow -> arrow == Map.from_struct(event) end)
    }

  defp apply_event(%FenLoaded{fen: fen}, state) do
    position = FenParser.parse!(fen)

    %{
      state
      | fen: fen,
        position: position.position,
        arrows: position.arrows,
        selected_square: nil
    }
  end

  defp apply_event(%SquareDeselected{}, state),
    do: %{state | selected_square: nil}

  defp apply_event(%SquareHighlighted{square_index: square_index, mode: :none}, state),
    do: %{
      state
      | highlighted_squares: Map.delete(state.highlighted_squares, square_index)
    }

  defp apply_event(%SquareHighlighted{square_index: square_index, mode: mode}, state),
    do: %{
      state
      | highlighted_squares: Map.merge(state.highlighted_squares, %{square_index => mode})
    }

  defp apply_event(%SquareSelected{square_index: square_index}, state),
    do: %{state | selected_square: square_index}

  defp apply_event(event, state) do
    IO.puts("Unknown event")
    IO.inspect(event)

    state
  end
end
