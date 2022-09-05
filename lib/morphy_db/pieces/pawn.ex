defmodule MorphyDb.Pieces.Pawn do
  defstruct []

  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(7), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), File.file(7))
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_left(9), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), File.file(0))
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def move_mask(%Position{} = position, %Square{rank: rank} = square, :w) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_left(8))
    |> initial_square(bitboard, rank, :w)
    |> Bitboard.except(position.all_pieces[:w])
    |> Bitboard.except(position.all_pieces[:b])
  end

  def move_mask(%Position{} = position, %Square{rank: rank} = square, :b) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_right(8))
    |> initial_square(bitboard, rank, :b)
    |> Bitboard.except(position.all_pieces[:w])
    |> Bitboard.except(position.all_pieces[:b])
  end

  defp initial_square(attacks, bitboard, 6, :b) do
    attacks
    |> Bitboard.union(bitboard |> Bitboard.shift_right(16))
  end

  defp initial_square(attacks, bitboard, 1, :w) do
    attacks
    |> Bitboard.union(bitboard |> Bitboard.shift_left(16))
  end

  defp initial_square(attacks, _, _, _) do
    attacks
  end
end
