defmodule MorphyDbWeb.Components.PieceComponent do
  use MorphyDbWeb, :surface_live_component

  prop square_index, :integer, required: true
  prop piece, :struct, required: true

  defp piece_image({c, p}) when is_atom(c) and is_atom(p) do
    "/images/#{translate_color(c)}_#{translate_piece(p)}.svg"
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
