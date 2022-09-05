defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position
  alias MorphyDb.Pieces.Piece

  alias MorphyDbWeb.Components.SquareComponent

  data selected_square, :struct, default: nil
  data selected_alt_squares, :integer, default: Bitboard.empty()
  data selected_ctrl_squares, :integer, default: Bitboard.empty()
  data move_squares, :integer, default: Bitboard.empty()
  data attacked_squares, :integer, default: Bitboard.empty()
  prop position, :struct

  def update(assigns, socket) do
    {:ok, socket |> setup(assigns.position)}
  end

  defp setup(socket, position) do
    squares =
      for(rank <- 7..0, file <- 0..7, do: 8 * rank + file)
      |> Enum.map(fn square -> Square.new(square) end)

    socket
    |> assign(:squares, squares)
    |> assign(:position, position)
    |> assign(:white_bottom, true)
  end

  def handle_event(
        "square_click",
        %{"square" => square_string, "alt_key" => false, "ctrl_key" => false},
        socket
      ) do
    square =
      square_string
      |> String.to_integer()
      |> Square.new()

    if has_selected_square(socket) do
      {:noreply, socket |> clear_selected_squares}
    else
      {:noreply, socket |> select_square(square)}
    end
  end

  def handle_event(
        "square_click",
        %{"square" => square_string, "alt_key" => true, "ctrl_key" => false},
        socket
      ) do
    square =
      square_string
      |> String.to_integer()
      |> Square.new()

    {:noreply,
     socket
     |> update(:selected_alt_squares, &Square.toggle(&1, square))
     |> assign(:selected_square, :nil)
     |> update(:selected_ctrl_squares, &Square.deselect(&1, square))}
  end

  def handle_event(
        "square_click",
        %{"square" => square_string, "alt_key" => false, "ctrl_key" => true},
        socket
      ) do
    square =
      square_string
      |> String.to_integer()
      |> Square.new()

    {:noreply,
     socket
     |> update(:selected_ctrl_squares, &Square.toggle(&1, square))
     |> assign(:selected_square, :nil)
     |> update(:selected_alt_squares, &Square.deselect(&1, square))}
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
      |> Enum.map(fn square -> Square.new(square) end)

    {:noreply,
     socket
     |> assign(:white_bottom, white_bottom)
     |> assign(:squares, squares)}
  end

  defp has_selected_square(socket) do
    socket.assigns
    |> Map.take([:selected_alt_squares, :selected_ctrl_squares])
    |> Map.values()
    |> Enum.map(fn bitboard -> bitboard.value end)
    |> Enum.sum() >
      0
  end

  defp select_square(socket, %Square{} = square) do
    if square === socket.assigns.selected_square,
      do:
        socket
        |> assign(:selected_square, nil)
        |> clear_attacked_squares()
        |> clear_move_squares(),
      else:
        socket
        |> assign(:selected_square, square)
        |> assign_attacked_squares(square)
        |> assign_move_squares(square)
  end

  defp assign_move_squares(socket, %Square{} = square) do
    position = socket.assigns.position

    {side, piece} = Position.piece(position, square)
    move_squares = Piece.Moves.mask(piece, position, square, side)

    socket |> assign(:move_squares, move_squares)
  end

  defp assign_attacked_squares(socket, %Square{} = square) do
    position = socket.assigns.position

    {side, piece} = Position.piece(position, square)
    attacked_squares = Piece.Attacks.mask(piece, position, square, side)

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
