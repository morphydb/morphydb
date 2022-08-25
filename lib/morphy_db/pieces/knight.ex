defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> calculate_attacks(bitboard |> Bitboard.shift_right(17), Board.h_file)
    |> calculate_attacks(bitboard |> Bitboard.shift_right(15), Board.a_file)
    |> calculate_attacks(bitboard |> Bitboard.shift_right(10), Board.g_file |> Bitboard.union(Board.h_file))
    |> calculate_attacks(bitboard |> Bitboard.shift_right(6), Board.a_file |> Bitboard.union(Board.b_file))

    |> calculate_attacks(bitboard |> Bitboard.shift_left(17), Board.a_file)
    |> calculate_attacks(bitboard |> Bitboard.shift_left(15), Board.h_file)
    |> calculate_attacks(bitboard |> Bitboard.shift_left(10), Board.a_file |> Bitboard.union(Board.b_file))
    |> calculate_attacks(bitboard |> Bitboard.shift_left(6), Board.g_file |> Bitboard.union(Board.h_file))
  end
end
