defmodule MorphyDb.Pieces.Rook do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Square

  def attack_mask(position, square_index, :w) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(position, square_index, :b) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(position, square_index, side) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, side))
  end

  defp unrestricted_movement(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    Bitboard.empty()
    |> Bitboard.union(Board.rank(rank_index))
    |> Bitboard.union(Board.file(file_index))
  end
end
