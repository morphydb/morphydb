defmodule ChessWeb.Components.GameComponent do
  alias Chess.Games.Commands.HighlightSquare
  alias Chess.Games.Commands.SelectSquare
  alias Chess.Games.Commands.LoadFen
  alias Chess.Games.Commands.ClearMarks
  alias Phoenix.LiveComponent

  alias Chess.Rooms.Room
  alias Chess.Games.Square
  alias Chess.Games.Position

  alias ChessWeb.Components.SquareComponent

  use ChessWeb, :live_component

  @impl LiveComponent
  def mount(socket) do
    {:ok, socket |> assign(:orientation, :w)}
  end

  @impl LiveComponent
  def render(assigns) do
    ~H"""
    <div
      id="game_component"
      class="flex gap-2"
      phx-window-keydown="keydown"
      phx-click-away="deselect"
      phx-target={@myself}
    >
      <div class="basis-2/3 lg:basis-5/12 flex flex-col gap-3">
        <div id="board" class="relative bg-slate-700" phx-hook="Board">
          <div class="grid grid-cols-8 grid-rows-8 aspect-square p-4">
            <%= for square <- Position.squares(@orientation) do %>
              <.live_component
                module={SquareComponent}
                id={"square-#{square.index}"}
                square={square}
                selected={@selected_square === square.index}
                piece={@position |> find_piece(square)}
                highlighted={Map.get(@highlighted_squares, square.index) == :normal}
                highlighted_alt={Map.get(@highlighted_squares, square.index) == :alt}
                highlighted_ctrl={Map.get(@highlighted_squares, square.index) == :ctrl}
              />
            <% end %>
          </div>
          <svg-container orientation={@orientation}>
            <%= for arrow <- @arrows do %>
              <svg-arrow from={"square-#{arrow.from}"} to={"square-#{arrow.to}"}></svg-arrow>
            <% end %>
          </svg-container>
        </div>

        <form class="flex gap-2" phx-submit="load_fen" phx-target={@myself}>
          <input
            type="text"
            name="fen"
            autocomplete="off"
            value={@fen}
            class="form-control input input-bordered w-full font-mono"
          />
          <button type="submit" class="btn"><%= dgettext("game", "Load FEN") %></button>
        </form>
      </div>
      <div class="basis-1/3 lg:basis-7/12" phx-click="deselect" phx-target={@myself}>
        <div class="form-control max-w-fit">
          <div class="btn-group">
            <input
              type="radio"
              name="orientation"
              data-title={dgettext("game", "orientation_white")}
              class="btn"
              checked={@orientation === :w}
              phx-click="flip"
              phx-target={@myself}
              value="w"
            />
            <input
              type="radio"
              name="orientation"
              data-title={dgettext("game", "orientation_black")}
              class="btn"
              checked={@orientation === :b}
              phx-click="flip"
              phx-target={@myself}
              value="b"
            />
          </div>
        </div>
        <div class="max-w-fit">
          This is the move table <%= @orientation %>
        </div>
      </div>
    </div>
    """
  end

  defp find_piece(position, %Square{rank: rank, file: file}) do
    position |> Enum.at(7 - rank) |> Enum.at(7 - file)
  end

  @impl LiveComponent
  def handle_event("deselect", _params, socket) do
    #   Game.clear(socket.assigns.game_code)

    {:noreply, socket}
  end

  @impl LiveComponent
  alias Chess.Games.Commands.DrawArrow

  def handle_event("draw-arrow", %{"from" => from, "to" => to}, socket),
    do: socket |> dispatch(%DrawArrow{from: from, to: to})

  @impl LiveComponent
  def handle_event("flip", _params, socket), do: socket |> flip()

  @impl LiveComponent
  def handle_event("highlight", %{"alt_key" => true, "square_index" => square_index}, socket),
    do: socket |> dispatch(%HighlightSquare{square_index: square_index, mode: :alt})

  @impl LiveComponent
  def handle_event("highlight", %{"ctrl_key" => true, "square_index" => square_index}, socket),
    do:
      socket
      |> dispatch(%HighlightSquare{
        square_index: square_index,
        mode: :ctrl
      })

  @impl LiveComponent
  def handle_event(
        "highlight",
        %{"square_index" => square_index},
        socket
      ),
      do:
        socket
        |> dispatch(%HighlightSquare{
          square_index: square_index,
          mode: :normal
        })

  @impl LiveComponent
  def handle_event("keydown", %{"key" => "Escape"}, socket), do: socket |> dispatch(%ClearMarks{})

  @impl LiveComponent
  def handle_event("keydown", %{"key" => "f"}, socket), do: socket |> flip()

  @impl LiveComponent
  def handle_event("keydown", %{"key" => "F"}, socket), do: socket |> flip()

  @impl LiveComponent
  def handle_event("keydown", _params, socket), do: {:noreply, socket}

  @impl LiveComponent
  def handle_event("load_fen", %{"fen" => fen}, socket),
    do: socket |> dispatch(%LoadFen{fen: fen})

  @impl LiveComponent
  def handle_event(
        "select",
        %{"square_index" => square_index},
        socket
      ),
      do: socket |> dispatch(%SelectSquare{square_index: square_index})

  defp flip(%{assigns: %{orientation: :w}} = socket),
    do: {:noreply, assign(socket, :orientation, :b)}

  defp flip(%{assigns: %{orientation: :b}} = socket),
    do: {:noreply, assign(socket, :orientation, :w)}

  defp dispatch(%{assigns: %{room_id: room_id}} = socket, command) do
    Room.dispatch(room_id, command)
    {:noreply, socket}
  end
end
