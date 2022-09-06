defmodule MorphyDb.Pieces.Queen do
  defstruct []

  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook
  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Position

  def attack_mask(%Position{} = position, %Square{} = square, side)
      when side === :w or side === :b do
    Rook.attack_mask(position, square, side)
    |> Bitboard.union(Bishop.attack_mask(position, square, side))
  end

  def move_mask(%Position{} = position, %Square{} = square, side)
      when side === :w or side === :b do
    Rook.move_mask(position, square, side)
    |> Bitboard.union(Bishop.move_mask(position, square, side))
  end
end
