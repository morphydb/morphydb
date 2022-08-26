defmodule MorphyDb.Pieces.King do
  import MorphyDb.Square.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def move_mask(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> calculate_attacks(bitboard |> Board.down())
    |> calculate_attacks(bitboard |> Board.left(), Board.file(7))
    |> calculate_attacks(bitboard |> Board.up())
    |> calculate_attacks(bitboard |> Board.right(), Board.file(0))
    |> Bitboard.unset(square_index)
  end
end
