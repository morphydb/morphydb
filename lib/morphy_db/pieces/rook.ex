defmodule MorphyDb.Pieces.Rook do
  defstruct []

  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Rank
  alias MorphyDb.Position
  alias MorphyDb.File

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(%Position{} = position, %Square{} = square, side) do
    unrestricted_movement(square)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square, side))
  end

  defp unrestricted_movement(%Square{file: file, rank: rank}) do
    Bitboard.empty()
    |> Bitboard.union(Rank.rank(rank))
    |> Bitboard.union(File.file(file))
  end
end
