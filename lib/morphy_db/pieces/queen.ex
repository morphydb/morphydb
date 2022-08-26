defmodule MorphyDb.Pieces.Queen do
  import MorphyDb.Square.Guards

  alias MorphyDb.Pieces.Bishop
  alias MorphyDb.Pieces.Rook

  alias MorphyDb.Bitboard

  def move_mask(square_index) when is_square(square_index) do
    Rook.move_mask(square_index)
    |> Bitboard.union(Bishop.move_mask(square_index))
  end

end
