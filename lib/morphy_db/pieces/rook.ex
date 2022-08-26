defmodule MorphyDb.Pieces.Rook do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Square

  def attack_mask(position, square_index, color) when is_square(square_index) and is_side(color) do
    opponent = if color === :w, do: :b, else: :w

    move_mask_internal(position, square_index)
      |> Bitboard.intersect(position.all_pieces[opponent])
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    move_mask_internal(position, square_index)
      |> Bitboard.relative_complement(position.all_pieces.all)
      |> Bitboard.union(attack_mask(position, square_index, color))
  end

  defp move_mask_internal(_position, square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    Bitboard.empty()
      |> Bitboard.union(Board.rank(rank_index))
      |> Bitboard.union(Board.file(file_index))
  end
end
