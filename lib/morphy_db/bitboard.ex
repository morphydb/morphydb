defmodule MorphyDb.Bitboard do
  @type t() :: %MorphyDb.Bitboard{value: integer()}
  @type bitnumber() :: 0..63

  use Bitwise

  alias __MODULE__

  @enforce_keys [:value]
  defstruct value: 0

  def empty, do: Bitboard.new(0)
  def universal, do: Bitboard.new(0xFFFFFFFFFFFFFFFF)

  def new() do
    empty()
  end

  @spec new(integer()) :: MorphyDb.Bitboard.t()
  def new(value) do
    %Bitboard{value: value}
  end

  @doc """
    Returns true if the bit is set
  """
  @spec is_set?(t(), bitnumber()) :: boolean()
  def is_set?(%Bitboard{} = bitboard, bitnumber),
    do: get_bit(bitboard, bitnumber) === to_bit(bitnumber)

  @doc """
    Unsets the bit in the bitboard
  """
  @spec unset(MorphyDb.Bitboard.t(), bitnumber()) :: MorphyDb.Bitboard.t()
  def unset(%Bitboard{} = bitboard, bitnumber),
    do: if(is_set?(bitboard, bitnumber), do: toggle(bitboard, bitnumber), else: bitboard)

  @doc """
    Gets the bitboard with only the value at bitnumber
  """
  @spec get_bit(MorphyDb.Bitboard.t(), bitnumber()) :: bitnumber()
  def get_bit(%Bitboard{} = bitboard, bitnumber), do: band(bitboard.value, to_bit(bitnumber))

  @doc """
    Set the bit in the bitboard
  """
  @spec set_bit(MorphyDb.Bitboard.t(), bitnumber()) :: MorphyDb.Bitboard.t()
  def set_bit(%Bitboard{} = bitboard, bitnumber) do
    value = bor(bitboard.value, to_bit(bitnumber))
    Bitboard.new(value)
  end

  @doc """
    Toggles the bit located at bitnumber
  """
  @spec toggle(MorphyDb.Bitboard.t(), bitnumber()) :: MorphyDb.Bitboard.t()
  def toggle(%Bitboard{} = bitboard, bitnumber) do
    toggled = bxor(bitboard.value, to_bit(bitnumber))
    Bitboard.new(toggled)
  end

  @doc """
    Determines whether bitboard1 and bitboard2 intersects
  """
  @spec intersects?(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) :: boolean()
  def intersects?(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2),
    do: intersect(bitboard1, bitboard2).value > 0

  @doc """
    Returns the intersection of two bitboards
  """
  @spec intersect(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
  def intersect(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    intersection = band(bitboard1.value, bitboard2.value)
    Bitboard.new(intersection)
  end

  @doc """
    Returns the union of two bitboards
  """
  @spec union(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
  def union(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    union = bor(bitboard1.value, bitboard2.value)
    Bitboard.new(union)
  end

  @doc """
    Returns the complement of a bitboard
  """
  @spec complement(MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
  def complement(bitboard), do: difference(universal(), bitboard)

  @spec except(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
  def except(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    bitboard2
    |> complement()
    |> intersect(bitboard1)
  end

  @spec difference(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
  def difference(%Bitboard{} = bitboard1, %Bitboard{} = bitboard2) do
    difference = bxor(bitboard1.value, bitboard2.value)
    Bitboard.new(difference)
  end

  @spec shift_right(t(), bitnumber()) :: MorphyDb.Bitboard.t()
  def shift_right(bitboard, amount), do: Bitboard.new(bsr(bitboard.value, amount))

  @spec shift_left(t(), bitnumber()) :: MorphyDb.Bitboard.t()
  def shift_left(bitboard, amount), do: Bitboard.new(bitboard.value <<< amount)

  defp to_bit(bitnumber), do: bsl(1, bitnumber)

  def print(bitboard) do
    for rank <- 7..0 do
      for file <- 0..7 do
        square = MorphyDb.Square.new(MorphyDb.File.to_file(file), rank)

        if file === 0 do
          IO.write("  #{rank + 1}  ")
        end

        if is_set?(bitboard, MorphyDb.Square.to_index(square)) do
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
