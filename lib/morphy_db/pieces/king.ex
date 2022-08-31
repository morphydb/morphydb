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

  def move_mask(position, square_index, side) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, side))
  end

  def unrestricted_movement(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(8), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_right(7), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(1), Board.file(7))

    |> conditional_union(bitboard |> Bitboard.shift_left(8), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(9), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(1), Board.file(0))
  end
end
