defmodule MorphyDb.Pieces.King do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(position, square_index, :w) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(position, square_index, :b) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.relative_complement(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, color))
  end

  defp unrestricted_movement(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> conditional_union(bitboard |> Board.down(1))
    |> conditional_union(bitboard |> Board.down(1) |> Board.left(1), Board.file(7))
    |> conditional_union(bitboard |> Board.down(1) |> Board.right(1), Board.file(0))
    |> conditional_union(bitboard |> Board.left(1), Board.file(7))
    |> conditional_union(bitboard |> Board.up(1))
    |> conditional_union(bitboard |> Board.up(1) |> Board.left(1), Board.file(7))
    |> conditional_union(bitboard |> Board.up(1) |> Board.right(1), Board.file(0))
    |> conditional_union(bitboard |> Board.right(1), Board.file(0))
    |> Bitboard.unset(square_index)
  end
end
