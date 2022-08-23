defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  require MorphyDb.Bitboard
  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position

  alias MorphyDbWeb.Components.SquareComponent
  alias MorphyDbWeb.Components.PieceComponent

  data selected_squares, :integer, default: Bitboard.empty()
  data highlighted_squares, :integer, default: Bitboard.empty()
  data highlighted_alt_squares, :integer, default: Bitboard.empty()
  data highlighted_ctrl_squares, :integer, default: Bitboard.empty()
  data position, :struct
  prop fen, :string, required: true

  def update(assigns, socket) do
    position = Position.parse(assigns.fen)
    {:ok, assign(socket, :position, position)}
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index},
        socket
      ) do
    selected_square =
      square_index
      |> String.to_integer()
      |> (&Square.toggle(Bitboard.empty(), &1)).()

    {:noreply,
     socket
     |> update(
       :selected_squares,
       &if(&1 == selected_square or has_highlighted_squares(socket), do: 0, else: selected_square)
     )
     |> assign(:highlighted_squares, 0)
     |> assign(:highlighted_alt_squares, 0)
     |> assign(:highlighted_ctrl_squares, 0)}
  end

  def handle_event(
        "square_right_click",
        %{"square_index" => square_index, "alt_key" => false, "ctrl_key" => false},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:selected_squares, 0)
     |> update(:highlighted_squares, &Square.toggle(&1, String.to_integer(square_index)))}
  end

  def handle_event(
        "square_right_click",
        %{"square_index" => square_index, "alt_key" => true},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:selected_squares, 0)
     |> update(:highlighted_alt_squares, &Square.toggle(&1, String.to_integer(square_index)))}
  end

  def handle_event(
        "square_right_click",
        %{"square_index" => square_index, "alt_key" => false, "ctrl_key" => true},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:selected_squares, 0)
     |> update(:highlighted_ctrl_squares, &Square.toggle(&1, String.to_integer(square_index)))}
  end

  def handle_event("deselect", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_squares, 0)
     |> assign(:highlighted_squares, 0)
     |> assign(:highlighted_alt_squares, 0)
     |> assign(:highlighted_ctrl_squares, 0)}
  end

  defp has_highlighted_squares(socket) do
    socket.assigns
    |> Map.take([:highlighted_squares, :highlighted_alt_squares, :highlighted_ctrl_squares])
    |> Map.values()
    |> Enum.sum() >
      0
  end
end
