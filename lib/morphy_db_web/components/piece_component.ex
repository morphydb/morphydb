defmodule MorphyDbWeb.Components.PieceComponent do
  use MorphyDbWeb, :surface_component
  alias MorphyDb.Piece

  prop square_index, :integer, required: true
  prop piece, :struct, required: true

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
