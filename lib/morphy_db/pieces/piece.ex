defmodule MorphyDb.Pieces.Piece do
  defmacro calculate_attacks(attacks, bitboard, except \\ MorphyDb.Bitboard.empty) do
    quote do
      if not MorphyDb.Bitboard.intersects?(unquote(bitboard), unquote(except)) do
        unquote(attacks) |> MorphyDb.Bitboard.union(unquote(bitboard))
      else
        unquote(attacks)
      end
    end
  end
end
