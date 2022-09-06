defmodule MorphyDb.Pieces.Knight do
  defstruct []

  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Pieces.Piece.Attacks

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    move_mask(position, square, :w)
    |> Attacks.filter_friendly(position, :w)
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    move_mask(position, square, :b)
    |> Attacks.filter_friendly(position, :b)
  end

  def move_mask(%Position{} = position, %Square{} = square, side) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(17), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_right(15), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(10), File.files(6, 7))
    |> conditional_union(bitboard |> Bitboard.shift_right(6), File.files(0, 1))
    |> conditional_union(bitboard |> Bitboard.shift_left(17), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_left(15), File.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(10), File.files(0, 1))
    |> conditional_union(bitboard |> Bitboard.shift_left(6), File.files(6, 7))
    |> Bitboard.except(Position.pieces(position, side))
  end
end
