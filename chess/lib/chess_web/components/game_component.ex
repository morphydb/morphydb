defmodule ChessWeb.Components.GameComponent do
  alias Game.Position
  alias ChessWeb.Components.BoardComponent

  use ChessWeb, :live_component

  def mount(socket) do
    {:ok, socket |> assign(:selected, nil) |> assign(:orientation, :w)}
  end

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_game()}
  end

  def render(assigns) do
    ~H"""
    <div id="game_component" class="flex gap-2"
        phx-window-keydown="keydown"
        phx-click-away="deselect"
        phx-target={@myself}>
      <div class="basis-2/3 lg:basis-5/12 flex flex-col gap-3">
        <.live_component
          module={BoardComponent}
          id="board"
          position={@position}
          game_code={@game_code}
          orientation={@orientation}
        />

        <form class="flex gap-2" phx-submit="load_fen">
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
          This is the move table
        </div>
      </div>
    </div>
    """
  end

  def handle_event("deselect", _params, socket) do
    Game.clear(socket.assigns.game_code)

    {:noreply, assign(socket, :selected, nil)}
  end

  def handle_event("keydown", %{"key" => "Escape"}, socket) do
    Game.clear(socket.assigns.game_code)
    {:noreply, socket}
  end

  def handle_event("keydown", %{"key" => "f"}, socket), do: {:noreply, socket |> flip()}
  def handle_event("keydown", %{"key" => "F"}, socket), do: {:noreply, socket |> flip()}
  def handle_event("keydown", _params, socket), do: {:noreply, socket}

  def handle_event("flip", _params, socket), do: {:noreply, socket |> flip()}

  defp flip(%{assigns: %{orientation: :w}} = socket), do: assign(socket, :orientation, :b)
  defp flip(%{assigns: %{orientation: :b}} = socket), do: assign(socket, :orientation, :w)

  defp assign_game(socket) do
    {:ok, position} = Game.get_position(socket.assigns.game_code)

    socket
    |> assign(:position, position)
    |> assign(:fen, Position.to_fen(position))
  end
end
