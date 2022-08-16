defmodule MorphyDb.Bitboard do
  use Bitwise
  use MorphyDb.Constants

  define light_squares, 0x55AA55AA55AA55AA
  define dark_squares,  0xAA55AA55AA55AA55
  define empty,         0
  define universal,     0xFFFFFFFFFFFFFFFF

  def is_set(bitboard, square) do
    (square &&& bitboard) === square;
  end

  def toggle(bitboard, square) do
    bxor(bitboard, square)
  end
end
