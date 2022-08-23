defmodule MorphyDb.Bitboard do
  use Bitwise
  use MorphyDb.Constants

  define light_squares, 0x55AA55AA55AA55AA
  define dark_squares,  0xAA55AA55AA55AA55
  define empty,         0
  define universal,     0xFFFFFFFFFFFFFFFF

  @doc """
    Returns true if the bit is set
  """
  def is_set(bitboard, square_index) when square_index in 0..63 do
    get_bit(bitboard, square_index) === to_bit(square_index)
  end

  @doc """
    Unsets the bit in the bitboard
  """
  def unset(bitboard, square_index) when square_index in 0..63 do
    is_set(bitboard, square_index) && toggle(bitboard, square_index)
  end

  @doc """
    Gets the bitboard with only the value at square_index
  """
  def get_bit(bitboard, square_index) when square_index in 0..63 do
    band(bitboard, to_bit(square_index))
  end

  @doc """
    Set the bit in the bitboard
  """
  def set_bit(bitboard, square_index) when square_index in 0..63 do
    bor(bitboard, to_bit(square_index))
  end

  @doc """
    Toggles the bit located at square_index
  """
  def toggle(bitboard, square_index) when square_index in 0..63 do
    bxor(bitboard, to_bit(square_index))
  end

  defp to_bit(square_index) when square_index in 0..63 do
    1 <<< square_index
  end
end
