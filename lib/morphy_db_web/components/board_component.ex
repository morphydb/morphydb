defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position
  alias MorphyDb.Pieces.Piece

  alias MorphyDbWeb.Components.SquareComponent

  data selected_square, :integer, default: Bitboard.empty()
  data selected_alt_squares, :integer, default: Bitboard.empty()
  data selected_ctrl_squares, :integer, default: Bitboard.empty()
  data move_squares, :integer, default: Bitboard.empty()
  data attacked_squares, :integer, default: Bitboard.empty()
  data position, :struct

  prop fen, :string, required: true

  def update(assigns, socket) do
    position = Position.parse(assigns.fen)

    squares =
      for(rank <- 7..0, file <- 0..7, do: 8 * rank + file)
      |> generate_squares(position)

    {:ok,
     socket
     |> assign(:squares, squares)
     |> assign(:position, position)
     |> assign(:white_bottom, true)}
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index_string, "alt_key" => false, "ctrl_key" => false},
        socket
      ) do
    square_index = String.to_integer(square_index_string)

    if has_selected_square(socket) do
      {:noreply, socket |> clear_selected_squares}
    else
      {:noreply, socket |> select_square(square_index)}
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
     |> update(:selected_alt_squares, &Square.toggle(&1, square_index))
     |> update(:selected_square, &Square.deselect(&1, square_index))
     |> update(:selected_ctrl_squares, &Square.deselect(&1, square_index))}
  end

  def handle_event(
        "square_click",
        %{"square_index" => square_index_string, "alt_key" => false, "ctrl_key" => true},
        socket
      ) do
    square_index = String.to_integer(square_index_string)

    {:noreply,
     socket
     |> update(:selected_ctrl_squares, &Square.toggle(&1, square_index))
     |> update(:selected_square, &Square.deselect(&1, square_index))
     |> update(:selected_alt_squares, &Square.deselect(&1, square_index))}
  end

  def handle_event("square_click", %{"alt_key" => true, "ctrl_key" => true}, socket) do
    {:noreply, socket}
  end

  def handle_event("deselect", _params, socket) do
    {:noreply,
     socket
     |> clear_selected_squares()}
  end

  def handle_event("flip", _params, socket) do
    white_bottom = not socket.assigns.white_bottom

    squares =
      if white_bottom,
        do: for(rank <- 7..0, file <- 0..7, do: 8 * rank + file),
        else: for(rank <- 0..7, file <- 7..0, do: 8 * rank + file)

    position = socket.assigns.position

    {:noreply,
     socket
     |> assign(:white_bottom, white_bottom)
     |> assign(:squares, squares |> generate_squares(position))}
  end

  defp has_selected_square(socket) do
    socket.assigns
    |> Map.take([:selected_alt_squares, :selected_ctrl_squares])
    |> Map.values()
    |> Enum.sum() >
      0
  end

  defp generate_squares(squares, position) do
    squares
    |> Enum.map(fn square_index ->
      %{index: square_index, piece: Position.piece(position, square_index)}
    end)
  end

  defp select_square(socket, square_index) do
    selected_square = Bitboard.empty() |> Square.toggle(square_index)

    if selected_square == socket.assigns.selected_square,
      do:
        socket
        |> assign(:selected_square, Bitboard.empty())
        |> clear_attacked_squares()
        |> clear_move_squares(),
      else:
        socket
        |> assign(:selected_square, selected_square)
        |> assign_attacked_squares(square_index)
        |> assign_move_squares(square_index)
  end

  defp assign_move_squares(socket, square_index) when is_square(square_index) do
    position = socket.assigns.position

    {color, piece} = Position.piece(position, square_index)
    move_squares = Piece.Moves.mask(piece, position, square_index, color)

    socket |> assign(:move_squares, move_squares)
  end

  defp assign_attacked_squares(socket, square_index) when is_square(square_index) do
    position = socket.assigns.position

    {color, piece} = Position.piece(position, square_index)
    attacked_squares = Piece.Attacks.mask(piece, position, square_index, color)

    socket |> assign(:attacked_squares, attacked_squares)
  end

  defp clear_selected_squares(socket) do
    socket
    |> assign(:selected_square, Bitboard.empty())
    |> assign(:selected_alt_squares, Bitboard.empty())
    |> assign(:selected_ctrl_squares, Bitboard.empty())
    |> clear_attacked_squares
    |> clear_move_squares
  end

  defp clear_attacked_squares(socket) do
    socket |> assign(:attacked_squares, Bitboard.empty())
  end

  defp clear_move_squares(socket) do
    socket |> assign(:move_squares, Bitboard.empty())
  end
end
