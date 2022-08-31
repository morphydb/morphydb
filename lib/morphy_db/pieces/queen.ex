defmodule MorphyDb.Pieces.Queen do
  import MorphyDb.Guards

  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook
  alias MorphyDb.Bitboard

  def attack_mask(position, square_index, side)
      when is_square(square_index) and (side === :w or side === :b) do
    Rook.attack_mask(position, square_index, side)
    |> Bitboard.union(Bishop.attack_mask(position, square_index, side))
  end

  def move_mask(position, square_index, side)
      when is_square(square_index) and (side === :w or side === :b) do
    Rook.move_mask(position, square_index, side)
    |> Bitboard.union(Bishop.move_mask(position, square_index, side))
  end
end
