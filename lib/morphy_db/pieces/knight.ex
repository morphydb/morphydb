defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def move_mask(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> calculate_attacks(bitboard |> Bitboard.shift_right(17), Board.file(7))
    |> calculate_attacks(bitboard |> Bitboard.shift_right(15), Board.file(0))
    |> calculate_attacks(bitboard |> Bitboard.shift_right(10), Board.file(6) |> Bitboard.union(Board.file(7)))
    |> calculate_attacks(bitboard |> Bitboard.shift_right(6), Board.file(0) |> Bitboard.union(Board.file(1)))

    |> calculate_attacks(bitboard |> Bitboard.shift_left(17), Board.file(0))
    |> calculate_attacks(bitboard |> Bitboard.shift_left(15), Board.file(7))
    |> calculate_attacks(bitboard |> Bitboard.shift_left(10), Board.file(0) |> Bitboard.union(Board.file(1)))
    |> calculate_attacks(bitboard |> Bitboard.shift_left(6), Board.file(6) |> Bitboard.union(Board.file(7)))

    |> Bitboard.unset(square_index)
  end
end
