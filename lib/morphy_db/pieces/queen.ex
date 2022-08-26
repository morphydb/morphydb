defmodule MorphyDb.Pieces.Queen do
  import MorphyDb.Guards

  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook
  alias MorphyDb.Bitboard
  alias MorphyDb.Position

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, color) when is_square(square_index) and is_side(color) do
    move_mask(square_index)
    |> Bitboard.intersect(all_pieces[(if color === :w, do: :b, else: :w)])
  end

  def move_mask(square_index) when is_square(square_index) do
    Rook.move_mask(square_index)
    |> Bitboard.union(Bishop.move_mask(square_index))
  end

end
