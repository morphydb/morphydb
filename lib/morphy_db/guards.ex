defmodule MorphyDb.Guards do
  defguard is_square(square_index) when square_index in 0..63
  defguard is_bitboard(bitboard) when is_integer(bitboard)
end
