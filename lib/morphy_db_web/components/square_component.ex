defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_component
  alias MorphyDb.Square
  alias MorphyDb.Bitboard
  alias MorphyDbWeb.Components.PieceComponent

  prop click, :event, required: true
  prop square, :map, required: true

  prop selected_squares, :integer, required: true
  prop highlighted_squares, :integer, required: true
  prop highlighted_ctrl_squares, :integer, required: true
  prop highlighted_alt_squares, :integer, required: true

  defp is_selected(selected_squares, square_index), do: Bitboard.is_set(selected_squares, square_index)

  defp is_highlighted(highlighted_squares, square_index), do: Bitboard.is_set(highlighted_squares, square_index)

  defp is_ctrl_highlighted(highlighted_ctrl_squares, square_index), do: Bitboard.is_set(highlighted_ctrl_squares, square_index)

  defp is_alt_highlighted(highlighted_alt_squares, square_index), do: Bitboard.is_set(highlighted_alt_squares, square_index)

  defp is_light(square_index), do: Square.is_light(square_index)

  defp is_dark(square_index), do: Square.is_dark(square_index)
end
