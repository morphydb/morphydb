defmodule MorphyDbWeb.Components.BoardComponent do
  use MorphyDbWeb, :surface_live_component

  require MorphyDb.Bitboard
  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position

  alias MorphyDbWeb.Components.SquareComponent

  data selected_squares, :integer, default: Bitboard.empty()
  data selected_alt_squares, :integer, default: Bitboard.empty()
  data selected_ctrl_squares, :integer, default: Bitboard.empty()
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

    case has_selected_squares(socket) do
      true ->
        {:noreply,
         socket
         |> assign(:selected_alt_squares, Bitboard.empty())
         |> assign(:selected_squares, Bitboard.empty())
         |> assign(:selected_ctrl_squares, Bitboard.empty())}

      false ->
        selected_square =
          square_index
          |> (&Square.toggle(Bitboard.empty(), &1)).()

        {:noreply,
         socket
         |> update(
           :selected_squares,
           &if(&1 == selected_square or has_selected_squares(socket),
             do: Bitboard.empty(),
             else: selected_square
           )
         )}
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
     |> update(:selected_squares, &Square.deselect(&1, square_index))
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
     |> update(:selected_squares, &Square.deselect(&1, square_index))
     |> update(:selected_alt_squares, &Square.deselect(&1, square_index))}
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
     |> assign(:selected_alt_squares, 0)
     |> assign(:selected_ctrl_squares, 0)}
  end

  def handle_event("flip", _params, socket) do
    white_bottom = not socket.assigns.white_bottom

    squares = if white_bottom, do: for(rank <- 7..0, file <- 0..7, do: 8 * rank + file), else: for rank <- 0..7, file <- 7..0, do: 8 * rank + file

    position = socket.assigns.position

    {:noreply,
     socket
     |> assign(:white_bottom, white_bottom)
     |> assign(:squares, squares |> generate_squares(position))}
  end

  defp has_selected_squares(socket) do
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
end
