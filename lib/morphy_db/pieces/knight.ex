defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Pieces.Piece.Attacks

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    move_mask(position, square, :w)
    |> Attacks.filter_friendly(position, :w)
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    move_mask(position, square, :b)
    |> Attacks.filter_friendly(position, :b)
  end

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def move_mask(%Position{} = position, %Square{} = square, side) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(17), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_right(15), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_right(10), File.files(:g, :h))
    |> conditional_union(bitboard |> Bitboard.shift_right(6), File.files(:a, :b))
    |> conditional_union(bitboard |> Bitboard.shift_left(17), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_left(15), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_left(10), File.files(:a, :b))
    |> conditional_union(bitboard |> Bitboard.shift_left(6), File.files(:g, :h))
    |> Bitboard.except(Position.pieces(position, side))
  end
end
