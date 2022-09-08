defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Square
  alias MorphyDb.Position
  alias MorphyDb.Pieces.Piece

  alias MorphyDbWeb.Components.SquareComponent

  data selected_square, :struct, default: nil
  data selected_alt_squares, :integer, default: Bitboard.empty()
  data selected_ctrl_squares, :integer, default: Bitboard.empty()
  data move_squares, :integer, default: Bitboard.empty()
  data attacked_squares, :integer, default: Bitboard.empty()
  data arrow, :struct

  prop board, :struct

  def update(assigns, socket) do
    {:ok, socket |> setup(assigns.board)}
  end

  defp setup(socket, board) do
    socket
    |> assign(:board, board)
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

    if has_selected_square(socket) or socket.assigns.arrow !== %{} do
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
     |> assign(:selected_square, nil)
     |> clear_move_squares()
     |> clear_attacked_squares()
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
     |> assign(:selected_square, nil)
     |> clear_move_squares()
     |> clear_attacked_squares()
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
    board = socket.assigns.board

    {:noreply,
     socket
     |> assign(:board, Board.flip(board))
     |> push_event("arrow_redraw", %{})}
  end

  def handle_event("mousedown", %{"square" => square_string}, socket) do
    {:noreply,
     socket
     |> assign(:arrow, %{start: square_string, end: nil})
     |> push_event("arrow_start", %{square: square_string})}
  end

  def handle_event("mouseover", %{"square" => square_string}, socket) do
    {:noreply,
     socket
     |> update_mouseover(socket.assigns.arrow, square_string)}
  end

  def handle_event("mouseup", %{"square" => square_string}, socket) do
    {:noreply,
     socket
     |> assign(:arrow, %{})
     |> push_event("arrow_end", %{square: square_string})}
  end

  defp update_mouseover(socket, %{end: e}, square_string) when e === square_string, do: socket

  defp update_mouseover(socket, %{end: e} = arrow, square_string) when e !== square_string do
    socket
    |> assign(:arrow, %{arrow | end: square_string})
    |> push_event("arrow_update", %{square: square_string})
  end

  defp update_mouseover(socket, %{}, _), do: socket

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
    board = socket.assigns.board
    position = board.position

    {side, piece} = Position.piece(position, square)
    move_squares = Piece.Moves.mask(piece, position, square, side)

    socket |> assign(:move_squares, move_squares)
  end

  defp assign_attacked_squares(socket, %Square{} = square) do
    board = socket.assigns.board
    position = board.position

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
    |> clear_arrows
  end

  defp clear_attacked_squares(socket) do
    socket |> assign(:attacked_squares, Bitboard.empty())
  end

  defp clear_move_squares(socket) do
    socket |> assign(:move_squares, Bitboard.empty())
  end

  defp clear_arrows(socket),
    do:
      socket
      |> assign(:arrow, %{})
      |> push_event("arrow_clear", %{})
end
