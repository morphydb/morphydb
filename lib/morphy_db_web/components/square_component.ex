defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_component
  alias MorphyDb.Square
  alias MorphyDb.Piece

  prop piece, :struct, required: false
  prop click, :event, required: true
  prop square_index, :integer, required: true

  prop is_selected, :boolean, required: true
  prop is_highlighted, :boolean, required: true
  prop is_ctrl_highlighted, :boolean, required: true
  prop is_alt_highlighted, :boolean, required: true

  defp is_light(square_index) do
    Square.is_light(square_index)
  end

  defp is_dark(square_index) do
    Square.is_dark(square_index)
  end

  defp piece_image(%Piece{color: color, piece: piece}) do
    "/images/#{translate_color(color)}_#{translate_piece(piece)}.svg"
  end

  defp translate_color(:black), do: "b"
  defp translate_color(:white), do: "w"

  defp translate_piece(:king), do: "k"
  defp translate_piece(:queen), do: "q"
  defp translate_piece(:rook), do: "r"
  defp translate_piece(:bishop), do: "b"
  defp translate_piece(:knight), do: "n"
  defp translate_piece(:pawn), do: "p"
end
