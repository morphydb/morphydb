defmodule MorphyDb.File do
  @enforce_keys [:number]
  defstruct [:number]

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  def file(:a), do: file(0)
  def file(:b), do: file(1)
  def file(:c), do: file(2)
  def file(:d), do: file(3)
  def file(:e), do: file(4)
  def file(:f), do: file(5)
  def file(:g), do: file(6)
  def file(:h), do: file(7)

  def file(file), do: calculate_file(file)
  def files(f1, f2), do: file(f1) |> Bitboard.union(file(f2))

  defp calculate_file(file) do
    0..7
    |> Enum.map(fn rank -> Square.new(file, rank) end)
    |> Enum.reduce(Bitboard.empty(), fn square, bitboard ->
      Bitboard.set_bit(bitboard, square.index)
    end)
  end
end
