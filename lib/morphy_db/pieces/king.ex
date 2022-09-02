defmodule MorphyDb.Pieces.King do
  defstruct []

  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.File

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(%Position{} = position, %Square{} = square, side) do
    unrestricted_movement(square)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square, side))
  end

  defp unrestricted_movement(%Square{} = square) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(8), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_right(7), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(1), File.file(7))

    |> conditional_union(bitboard |> Bitboard.shift_left(8), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(9), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(1), File.file(0))
  end
end
