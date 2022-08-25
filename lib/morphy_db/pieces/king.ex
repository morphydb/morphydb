defmodule MorphyDb.Pieces.King do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> calculate_attacks(bitboard |> Bitboard.shift_right(8))                 # Down 1 rank
    |> calculate_attacks(bitboard |> Bitboard.shift_right(1), Board.h_file)   # Left 1 file
    |> calculate_attacks(bitboard |> Bitboard.shift_left(8))                  # Up 1 rank
    |> calculate_attacks(bitboard |> Bitboard.shift_left(1), Board.a_file)    # Right 1 file
  end

end
