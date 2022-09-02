defmodule MorphyDb.Rank do
  @enforce_keys [:number]
  defstruct [:number]

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  def rank(rank), do: calculate_rank(rank)

  defp calculate_rank(rank) do
    0..7
    |> Enum.map(fn file -> Square.new(file, rank) end)
    |> Enum.reduce(Bitboard.empty(), fn square, bitboard ->
      Bitboard.set_bit(bitboard, square.index)
    end)
  end
end
