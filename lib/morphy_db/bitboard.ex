defmodule MorphyDb.Bitboard do
  use Bitwise
  import MorphyDb.Guards

  @type bitboard :: integer()

  def empty, do: 0
  def universal, do: 0xFFFFFFFFFFFFFFFF

  @doc """
    Returns true if the bit is set
  """
  @spec is_set?(bitboard, byte) :: boolean
  def is_set?(bitboard, square_index) when is_bitboard(bitboard) and is_square(square_index) do
    get_bit(bitboard, square_index) === to_bit(square_index)
  end

  @doc """
    Unsets the bit in the bitboard
  """
  @spec unset(bitboard, byte) :: bitboard
  def unset(bitboard, square_index) when is_bitboard(bitboard) and is_square(square_index) do
    if is_set?(bitboard, square_index), do: toggle(bitboard, square_index), else: bitboard
  end

  @doc """
    Gets the bitboard with only the value at square_index
  """
  @spec get_bit(bitboard, byte) :: bitboard
  def get_bit(bitboard, square_index) when is_bitboard(bitboard) and is_square(square_index) do
    band(bitboard, to_bit(square_index))
  end

  @doc """
    Set the bit in the bitboard
  """
  @spec set_bit(bitboard, byte) :: bitboard
  def set_bit(bitboard, square_index) when is_bitboard(bitboard) and is_square(square_index) do
    bor(bitboard, to_bit(square_index))
  end

  @doc """
    Toggles the bit located at square_index
  """
  @spec toggle(bitboard, byte) :: bitboard
  def toggle(bitboard, square_index) when is_bitboard(bitboard) and is_square(square_index) do
    bxor(bitboard, to_bit(square_index))
  end

  @doc """
    Returns the intersection of two bitboards
  """
  @spec intersect(bitboard, bitboard) :: bitboard
  def intersect(bitboard1, bitboard2) when is_bitboard(bitboard1) and is_bitboard(bitboard2) do
    band(bitboard1, bitboard2)
  end

  @doc """
    Determines whether bitboard1 and bitboard2 intersects
  """
  @spec intersects?(bitboard, bitboard) :: boolean
  def intersects?(bitboard1, bitboard2) when is_bitboard(bitboard1) and is_bitboard(bitboard2) do
    intersect(bitboard1, bitboard2) > 0
  end

  @doc """
    Returns the union of two bitboards
  """
  @spec union(bitboard, bitboard) :: bitboard
  def union(bitboard1, bitboard2) when is_bitboard(bitboard1) and is_bitboard(bitboard2) do
    bor(bitboard1, bitboard2)
  end

  @doc """
    Returns the complement of a bitboard
  """
  @spec complement(bitboard) :: bitboard
  def complement(bitboard) when is_bitboard(bitboard) do
    difference(universal(), bitboard)
  end

  @spec except(bitboard, bitboard) :: bitboard
  defdelegate except(bitboard1, bitboard2), to: __MODULE__, as: :relative_complement

  @spec relative_complement(bitboard, bitboard) :: bitboard
  def relative_complement(bitboard1, bitboard2)
      when is_bitboard(bitboard1) and is_bitboard(bitboard2) do
    intersect(complement(bitboard2), bitboard1)
  end

  @spec difference(bitboard, bitboard) :: bitboard
  def difference(bitboard1, bitboard2) when is_bitboard(bitboard1) and is_bitboard(bitboard2) do
    bxor(bitboard1, bitboard2)
  end

  @spec shift_right(bitboard, bitboard) :: bitboard
  def shift_right(bitboard, amount) when is_bitboard(bitboard) and is_bitboard(amount) do
    bsr(bitboard, amount)
  end

  @spec shift_left(bitboard, bitboard) :: bitboard
  def shift_left(bitboard, amount) when is_bitboard(bitboard) and is_bitboard(amount) do
    bitboard <<< amount
  end

  @spec count(bitboard) :: bitboard
  def count(0), do: 0

  def count(bitboard) when is_bitboard(bitboard) do
    count(div(bitboard, 2)) + rem(bitboard, 2)
  end

  @spec least_significant_bit(bitboard) :: bitboard
  def least_significant_bit(bitboard) when is_bitboard(bitboard) do
    intersect(bitboard, -bitboard) - 1
  end

  @spec least_significant_bit_index(bitboard) :: integer
  def least_significant_bit_index(bitboard) when is_bitboard(bitboard) do
    bitboard
    |> least_significant_bit()
    |> count()
  end

  defp to_bit(square_index) when is_square(square_index) do
    bsl(1, square_index)
  end

  def print(bitboard) do
    for rank <- 7..0 do
      for file <- 0..7 do
        square = MorphyDb.Square.to_square_index(file, rank)

        if file === 0 do
          IO.write("  #{rank + 1}  ")
        end

        if is_set?(bitboard, square) do
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
