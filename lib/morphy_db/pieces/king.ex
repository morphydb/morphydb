defmodule MorphyDb.Pieces.King do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, color) when is_square(square_index) and is_side(color) do
    move_mask(square_index)
    |> Bitboard.intersect(all_pieces[(if color === :w, do: :b, else: :w)])
  end

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
