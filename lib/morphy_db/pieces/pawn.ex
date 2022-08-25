defmodule MorphyDb.Pieces.Pawn do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(square_index, side) when is_square(square_index) and (side == :w or side == :b) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    case side do
      :b ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Bitboard.shift_right(7), Board.a_file())
        |> calculate_attacks(bitboard |> Bitboard.shift_right(9), Board.h_file())

      :w ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Bitboard.shift_left(9), Board.a_file())
        |> calculate_attacks(bitboard |> Bitboard.shift_left(7), Board.h_file())
    end
  end
end
