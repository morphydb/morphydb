defmodule MorphyDb.Bitboard do
  use Bitwise
  use MorphyDb.Constants

  define light_squares, 0x55AA55AA55AA55AA
  define dark_squares,  0xAA55AA55AA55AA55
  define empty,         0
  define universal,     0xFFFFFFFFFFFFFFFF

  def is_set(bitboard, bit) do
    (bit &&& bitboard) === bit;
  end

  def toggle(bitboard, bit) do
    bxor(bitboard, bit)
  end
end
