defmodule MorphyDb.Pieces.Rook do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position
  alias MorphyDb.Square

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, color) when is_square(square_index) and is_side(color) do
    move_mask(square_index)
    |> Bitboard.intersect(all_pieces[(if color === :w, do: :b, else: :w)])
  end

  def move_mask(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    Bitboard.empty()
      |> Bitboard.union(Board.rank(rank_index))
      |> Bitboard.union(Board.file(file_index))
      |> Bitboard.unset(square_index)
  end
end
