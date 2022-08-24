defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  require MorphyDb.Bitboard
  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position

  alias MorphyDbWeb.Components.SquareComponent

  data selected_squares, :integer, default: Bitboard.empty
  data highlighted_alt_squares, :integer, default: Bitboard.empty
  data highlighted_ctrl_squares, :integer, default: Bitboard.empty
  data position, :struct

  prop fen, :string, required: true

  def update(assigns, socket) do
    position = Position.parse(assigns.fen)

    squares =
      (for rank <- 7..0, file <- 0..7, do: 8 * rank + file)
      |> Enum.map(fn square_index -> %{index: square_index, piece: Position.piece(position, square_index)} end)

    {:ok,
      socket
      |> assign(:squares, squares)
      |> assign(:pieces, position.pieces)
    }
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index_string, "alt_key" => false, "ctrl_key" => false},
        socket
      ) do

    square_index = String.to_integer(square_index_string)

    case has_highlighted_squares(socket) do
      true ->
        {:noreply,
          socket
          |> assign(:highlighted_alt_squares, Bitboard.empty)
          |> assign(:selected_squares, Bitboard.empty)
          |> assign(:highlighted_ctrl_squares, Bitboard.empty)
        }
      false ->
        {:noreply,
          socket
          |> assign(:selected_squares, Square.toggle(Bitboard.empty, square_index))
        }
    end
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index_string, "alt_key" => true, "ctrl_key" => false},
        socket
      ) do
    square_index = String.to_integer(square_index_string)

    {:noreply,
     socket
     |> update(:highlighted_alt_squares, &Square.toggle(&1, square_index))
     |> update(:selected_squares, &Square.deselect(&1, square_index))
     |> update(:highlighted_ctrl_squares, &Square.deselect(&1, square_index))
    }
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index_string, "alt_key" => false, "ctrl_key" => true},
        socket
      ) do
    square_index = String.to_integer(square_index_string)

    {:noreply,
     socket
     |> update(:highlighted_ctrl_squares, &Square.toggle(&1, square_index))
     |> update(:selected_squares, &Square.deselect(&1, square_index))
     |> update(:highlighted_alt_squares, &Square.deselect(&1, square_index))
    }
  end

  def handle_event(
        "square_click",
        %{"alt_key" => true, "ctrl_key" => true},
        socket
      ) do
    {:noreply, socket}
  end

  def handle_event("deselect", _params, socket) do
    {:noreply,
     socket
     |> assign(:selected_squares, 0)
     |> assign(:highlighted_alt_squares, 0)
     |> assign(:highlighted_ctrl_squares, 0)}
  end

  defp has_highlighted_squares(socket) do
    socket.assigns
    |> Map.take([:highlighted_alt_squares, :highlighted_ctrl_squares])
    |> Map.values()
    |> Enum.sum() >
      0
  end
end
