defmodule MorphyDb.Bitboard do
  use Bitwise
  import MorphyDb.Guards

  def empty, do: 0
  def universal, do: 0xFFFFFFFFFFFFFFFF
  def light_squares, do: 0x55AA55AA55AA55AA
  def dark_squares, do: 0xAA55AA55AA55AA55

  @doc """
    Returns true if the bit is set
  """
  @spec is_set(integer, byte) :: boolean
  def is_set(bitboard, square_index) when is_integer(bitboard) and is_square(square_index) do
    get_bit(bitboard, square_index) === to_bit(square_index)
  end

  @doc """
    Unsets the bit in the bitboard
  """
  @spec unset(integer, byte) :: integer
  def unset(bitboard, square_index) when is_integer(bitboard) and is_square(square_index) do
    if is_set(bitboard, square_index), do: toggle(bitboard, square_index), else: bitboard
  end

  @doc """
    Gets the bitboard with only the value at square_index
  """
  @spec get_bit(integer, byte) :: non_neg_integer
  def get_bit(bitboard, square_index) when is_integer(bitboard) and is_square(square_index) do
    band(bitboard, to_bit(square_index))
  end

  @doc """
    Set the bit in the bitboard
  """
  @spec set_bit(integer, byte) :: integer
  def set_bit(bitboard, square_index) when is_integer(bitboard) and is_square(square_index) do
    bor(bitboard, to_bit(square_index))
  end

  @doc """
    Toggles the bit located at square_index
  """
  @spec toggle(integer, byte) :: integer
  def toggle(bitboard, square_index) when is_integer(bitboard) and is_square(square_index) do
    bxor(bitboard, to_bit(square_index))
  end

  @spec intersect(integer, integer) :: integer
  def intersect(bitboard1, bitboard2) when is_integer(bitboard1) and is_integer(bitboard2) do
    band(bitboard1, bitboard2)
  end

  def intersects?(bitboard1, bitboard2) when is_integer(bitboard1) and is_integer(bitboard2) do
    intersect(bitboard1, bitboard2) > 0
  end

  @spec union(integer, integer) :: integer
  def union(bitboard1, bitboard2) when is_integer(bitboard1) and is_integer(bitboard2) do
    bor(bitboard1, bitboard2)
  end

  @spec complement(integer) :: integer
  def complement(bitboard) when is_integer(bitboard) do
    bnot(bitboard)
  end

  @spec difference(integer, integer) :: integer
  def difference(bitboard1, bitboard2) when is_integer(bitboard1) and is_integer(bitboard2) do
    bxor(bitboard1, bitboard2)
  end

  @spec shift_right(integer, integer) :: integer
  def shift_right(bitboard, amount) when is_integer(bitboard) and is_integer(amount) do
    bsr(bitboard, amount)
  end

  @spec shift_left(integer, integer) :: integer
  def shift_left(bitboard, amount) when is_integer(bitboard) and is_integer(amount) do
    bitboard <<< amount
  end

  defp to_bit(square_index) when is_square(square_index) do
    bsl(1, square_index)
  end

  def print(bitboard) do
    for rank <- 7..0 do
      for file <- 0..7 do
        square = MorphyDb.Square.to_square_index(file, rank)

        if (file === 0) do
          IO.write("  #{rank + 1}  ")
        end

        if (is_set(bitboard, square)) do
          IO.write(" 1 ")
        else
          IO.write(" . ")
        end
      end

      IO.puts("")
    end

    IO.puts("      A  B  C  D  E  F  G  H")
    IO.puts("")
    IO.puts("      Bitboard: #{bitboard}")
  end
end
