defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Guards

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

  def move_mask(_position, square_index, _color) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Board.down(2) |> Board.left(1))
    |> Bitboard.union(bitboard |> Board.down(1) |> Board.left(2))

    |> Bitboard.union(bitboard |> Board.down(2) |> Board.right(1))
    |> Bitboard.union(bitboard |> Board.down(1) |> Board.right(2))

    |> Bitboard.union(bitboard |> Board.up(2) |> Board.left(1))
    |> Bitboard.union(bitboard |> Board.up(1) |> Board.left(2))

    |> Bitboard.union(bitboard |> Board.up(2) |> Board.right(1))
    |> Bitboard.union(bitboard |> Board.up(1) |> Board.right(2))
    |> Bitboard.unset(square_index)
  end
end
