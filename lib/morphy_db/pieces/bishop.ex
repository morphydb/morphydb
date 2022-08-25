defmodule MorphyDb.Pieces.Bishop do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(square_index) when is_square(square_index) do
    Bitboard.empty()
  end

end
