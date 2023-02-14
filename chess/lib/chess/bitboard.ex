defmodule Chess.Bitboard do
  import Bitwise

  alias __MODULE__

  @enforce_keys [:value]
  defstruct @enforce_keys

  @opaque t() :: %Bitboard{
            value: integer()
          }

  defp new(value), do: %Bitboard{value: value}

  def empty(), do: new(0)

  def set(%Bitboard{value: bitboard}, bit),
    do:
      bitboard
      |> bor(2 ** bit)
      |> new()

  def set?(%Bitboard{value: bitboard}, bit),
    do:
      bitboard
      |> band(2 ** bit)
      |> new() != empty()

  def clear(%Bitboard{} = bitboard, bit),
    do: if(set?(bitboard, bit), do: toggle(bitboard, bit), else: bitboard)

  def toggle(%Bitboard{value: bitboard}, bit),
    do:
      bxor(bitboard, 2 ** bit)
      |> new()

  def intersection(%Bitboard{value: b1}, %Bitboard{value: b2}),
    do:
      band(b1, b2)
      |> new()

  def intersects?(b1, b2), do: intersection(b1, b2) != empty()

  def union(%Bitboard{value: b1}, %Bitboard{value: b2}),
    do:
      bor(b1, b2)
      |> new()
end
