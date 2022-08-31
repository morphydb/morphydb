defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position

  def attack_mask(position = %Position{all_pieces: all_pieces}, square_index, :w)
      when is_square(square_index) do
    move_mask(position, square_index, :w)
    |> Bitboard.intersect(all_pieces[:b])
  end

  def attack_mask(position = %Position{all_pieces: all_pieces}, square_index, :b)
      when is_square(square_index) do
    move_mask(position, square_index, :b)
    |> Bitboard.intersect(all_pieces[:w])
  end

  def move_mask(position, square_index, side) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(17), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_right(15), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(10), Board.files(6, 7))
    |> conditional_union(bitboard |> Bitboard.shift_right(6), Board.files(0, 1))

    |> conditional_union(bitboard |> Bitboard.shift_left(17), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_left(15), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(10), Board.files(0, 1))
    |> conditional_union(bitboard |> Bitboard.shift_left(6), Board.files(6, 7))

    |> Bitboard.except(position.all_pieces[side])
  end
end
