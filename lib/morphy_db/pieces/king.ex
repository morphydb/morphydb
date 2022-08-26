defmodule MorphyDb.Pieces.King do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(position, square_index, color)
      when is_square(square_index) and is_side(color) do
    opponent = if color === :w, do: :b, else: :w

    move_mask_internal(position, square_index)
    |> Bitboard.intersect(position.all_pieces[opponent])
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    move_mask_internal(position, square_index)
    |> Bitboard.relative_complement(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, color))
  end

  def move_mask_internal(_position, square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> calculate_attacks(bitboard |> Board.down())
    |> calculate_attacks(bitboard |> Board.down() |> Board.left(), Board.file(7))
    |> calculate_attacks(bitboard |> Board.down() |> Board.right(), Board.file(0))
    |> calculate_attacks(bitboard |> Board.left(), Board.file(7))
    |> calculate_attacks(bitboard |> Board.up())
    |> calculate_attacks(bitboard |> Board.up() |> Board.left(), Board.file(7))
    |> calculate_attacks(bitboard |> Board.up() |> Board.right(), Board.file(0))
    |> calculate_attacks(bitboard |> Board.right(), Board.file(0))
    |> Bitboard.unset(square_index)
  end
end
