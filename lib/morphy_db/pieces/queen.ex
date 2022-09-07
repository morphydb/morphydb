defmodule MorphyDb.Pieces.Queen do
  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook
  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Position

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, side) do
    Rook.attack_mask(position, square, side)
    |> Bitboard.union(Bishop.attack_mask(position, square, side))
  end

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def move_mask(%Position{} = position, %Square{} = square, side) do
    Rook.move_mask(position, square, side)
    |> Bitboard.union(Bishop.move_mask(position, square, side))
  end
end
