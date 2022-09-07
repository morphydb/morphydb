defmodule MorphyDb.Rank do
  @type t() :: 0..7

  @enforce_keys [:number]
  defstruct [:number]

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  @spec rank(t()) :: Bitboard.t()
  def rank(rank), do: calculate_rank(rank)

  defp calculate_rank(rank) do
    0..7
    |> Enum.map(fn file -> Square.new(file, rank) end)
    |> Enum.reduce(Bitboard.empty(), fn square, bitboard ->
      Bitboard.set_bit(bitboard, Square.to_index(square))
    end)
  end
end
