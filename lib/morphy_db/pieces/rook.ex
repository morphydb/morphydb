defmodule MorphyDb.Pieces.Rook do
  import MorphyDb.Square.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Square

  def move_mask(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    Bitboard.empty()
      |> Bitboard.union(Board.rank(rank_index))
      |> Bitboard.union(Board.file(file_index))
      |> Bitboard.unset(square_index)
  end
end
