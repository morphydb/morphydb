defmodule MorphyDb.Bitboard do
  use Bitwise

  alias __MODULE__

  @enforce_keys [:value]
  defstruct value: 0

  def empty, do: Bitboard.new(0)
  def universal, do: Bitboard.new(0xFFFFFFFFFFFFFFFF)

  def new() do
    empty()
  end

  def new(value) do
    %Bitboard{value: value}
  end

  @doc """
    Returns true if the bit is set
  """
  def is_set?(%Bitboard{} = bitboard, bitnumber),
    do: get_bit(bitboard, bitnumber) === to_bit(bitnumber)

  @doc """
    Unsets the bit in the bitboard
  """
  def unset(%Bitboard{} = bitboard, bitnumber),
    do: if(is_set?(bitboard, bitnumber), do: toggle(bitboard, bitnumber), else: bitboard)

  @doc """
    Gets the bitboard with only the value at bitnumber
  """
  def get_bit(%Bitboard{} = bitboard, bitnumber), do: band(bitboard.value, to_bit(bitnumber))

  @doc """
    Set the bit in the bitboard
  """
  def set_bit(%Bitboard{} = bitboard, bitnumber) do
    value = bor(bitboard.value, to_bit(bitnumber))
    Bitboard.new(value)
  end

  @doc """
    Toggles the bit located at bitnumber
  """
  def toggle(%Bitboard{} = bitboard, bitnumber) do
    toggled = bxor(bitboard.value, to_bit(bitnumber))
    Bitboard.new(toggled)
  end

  @doc """
    Determines whether bitboard1 and bitboard2 intersects
  """
  def intersects?(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2),
    do: intersect(bitboard1, bitboard2).value > 0

  @doc """
    Returns the intersection of two bitboards
  """
  def intersect(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    intersection = band(bitboard1.value, bitboard2.value)
    Bitboard.new(intersection)
  end

  @doc """
    Returns the union of two bitboards
  """
  def union(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    union = bor(bitboard1.value, bitboard2.value)
    Bitboard.new(union)
  end

  @doc """
    Returns the complement of a bitboard
  """
  def complement(bitboard), do: difference(universal(), bitboard)

  def except(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    bitboard2
    |> complement()
    |> intersect(bitboard1)
  end

  def difference(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    difference = bxor(bitboard1.value, bitboard2.value)
    Bitboard.new(difference)
  end

  def shift_right(bitboard, amount), do: Bitboard.new(bsr(bitboard.value, amount))

  def shift_left(bitboard, amount), do: Bitboard.new(bitboard.value <<< amount)

  def count(0), do: 0

  def count(bitboard), do: count(div(bitboard.value, 2) + rem(bitboard.value, 2))

  defp to_bit(bitnumber), do: bsl(1, bitnumber)

  def print(bitboard) do
    for rank <- 7..0 do
      for file <- 0..7 do
        square = MorphyDb.Square.new(file, rank)

        if file === 0 do
          IO.write("  #{rank + 1}  ")
        end

        if is_set?(bitboard, square.index) do
          IO.write(" 1 ")
        else
          IO.write(" . ")
        end
      end

      IO.puts("")
    end

    IO.puts("      A  B  C  D  E  F  G  H")
    IO.puts("")
    IO.puts("      Bitboard: #{bitboard.value}")
  end
end
