defmodule ChessWeb.Components.BoardComponent do
  alias Chess.Bitboard
  alias Chess.Games.Position
  alias Chess.Games.Square

  alias ChessWeb.Components.SquareComponent

  use ChessWeb, :live_component

  def mount(socket) do
    {:ok, socket |> assign(:selected, nil)}
  end

  def render(assigns) do
    ~H"""
    <div id="board" class="relative bg-slate-700" phx-hook="Board">
      <div class="grid grid-cols-8 grid-rows-8 aspect-square p-4">
        <%= for square <- Position.squares(@orientation) do %>
          <.live_component
            module={SquareComponent}
            id={"square-#{square.index}"}
            square={square}
            selected={@selected === square.index}
            piece={@position |> find_piece(square)}
          />
          <%!-- highlighted={@position.highlight |> Bitboard.set?(square.index)}
            highlighted_alt={@position.highlight_alt |> Bitboard.set?(square.index)}
            highlighted_ctrl={@position.highlight_ctrl |> Bitboard.set?(square.index)} --%>
        <% end %>
      </div>
      <svg-container orientation={@orientation}>
        <%= for arrow <- @arrows do %>
          <svg-arrow from={"square-#{arrow.from}"} to={"square-#{arrow.to}"}></svg-arrow>
        <% end %>
      </svg-container>
    </div>
    """
  end

  defp find_piece(position, %Square{rank: rank, file: file}) do
    nil
  end

  # def handle_event("draw-arrow", %{"from" => from, "to" => to}, socket) do
  #   Game.arrow(socket.assigns.game_code, %{from: from, to: to})

  #   {:noreply, socket}
  # end

  # def handle_event(
  #       "highlight",
  #       %{"square_index" => square_index, "alt_key" => false, "ctrl_key" => false},
  #       socket
  #     ) do
  #   {:ok, _} = Game.highlight(socket.assigns.game_code, square_index)
  #   {:noreply, socket}
  # end

  # def handle_event("highlight", %{"square_index" => square_index, "alt_key" => true}, socket) do
  #   {:ok, _} = Game.highlight(socket.assigns.game_code, square_index, :alt)
  #   {:noreply, socket}
  # end

  # def handle_event("highlight", %{"square_index" => square_index, "ctrl_key" => true}, socket) do
  #   {:ok, _} = Game.highlight(socket.assigns.game_code, square_index, :ctrl)
  #   {:noreply, socket}
  # end

  # def handle_event(
  #       "select",
  #       %{"square_index" => square_index},
  #       %{assigns: %{selected: selected}} = socket
  #     )
  #     when selected == square_index do
  #   Game.clear(socket.assigns.game_code)

  #   {:noreply, socket |> assign(:selected, nil)}
  # end

  # def handle_event(
  #       "select",
  #       %{"square_index" => square_index},
  #       socket
  #     ) do
  #   Game.clear(socket.assigns.game_code)

  #   {:noreply, socket |> assign(:selected, square_index)}
  # end
end
