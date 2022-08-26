defmodule MorphyDb.Pieces.Queen do
  import MorphyDb.Guards

  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook
  alias MorphyDb.Bitboard

  def attack_mask(position, square_index, color) when is_square(square_index) and is_side(color) do
    Rook.attack_mask(position, square_index, color)
    |> Bitboard.union(Bishop.attack_mask(position, square_index, color))
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    Rook.move_mask(position, square_index, color)
    |> Bitboard.union(Bishop.move_mask(position, square_index, color))
  end

end
