defmodule MorphyDb.File do
  @type t() :: :a | :b | :c | :d | :e | :f | :g | :h

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  @spec file(t()) :: Bitboard.t()
  def file(file), do: file |> calculate_file

  @spec files(t(), t()) :: Bitboard.t()
  def files(f1, f2), do: file(f1) |> Bitboard.union(file(f2))

  @spec to_integer(t()) :: 0..7
  def to_integer(:a), do: 0
  def to_integer(:b), do: 1
  def to_integer(:c), do: 2
  def to_integer(:d), do: 3
  def to_integer(:e), do: 4
  def to_integer(:f), do: 5
  def to_integer(:g), do: 6
  def to_integer(:h), do: 7

  @spec to_file(0..7) :: t()
  def to_file(0), do: :a
  def to_file(1), do: :b
  def to_file(2), do: :c
  def to_file(3), do: :d
  def to_file(4), do: :e
  def to_file(5), do: :f
  def to_file(6), do: :g
  def to_file(7), do: :h

  defp calculate_file(file) do
    0..7
    |> Enum.map(fn rank -> Square.new(file, rank) end)
    |> Enum.reduce(Bitboard.empty(), fn square, bitboard ->
      Bitboard.set_bit(bitboard, Square.to_index(square))
    end)
  end
end
