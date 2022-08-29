defmodule MorphyDbWeb.Components.PieceComponent do
  use MorphyDbWeb, :surface_live_component

  prop square_index, :integer, required: true
  prop piece, :struct, required: true

  defp piece_image({nil, nil}) do
    "images/none.svg"
  end

  defp piece_image({color, piece}) when is_atom(color) and is_atom(piece) do
    "/images/#{translate_color(color)}_#{translate_piece(piece)}.svg"
  end

  defp translate_color(:b), do: "b"
  defp translate_color(:w), do: "w"

  defp translate_piece(:k), do: "k"
  defp translate_piece(:q), do: "q"
  defp translate_piece(:r), do: "r"
  defp translate_piece(:b), do: "b"
  defp translate_piece(:n), do: "n"
  defp translate_piece(:p), do: "p"
end
