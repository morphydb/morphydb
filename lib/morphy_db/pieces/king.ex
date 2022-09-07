defmodule MorphyDb.Pieces.King do
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.File
  alias MorphyDb.Pieces.Piece.Attacks

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    unrestricted_movement(square)
    |> Attacks.filter_friendly(position, :w)
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    unrestricted_movement(square)
    |> Attacks.filter_friendly(position, :b)
  end

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def move_mask(%Position{} = position, %Square{} = square, side) do
    unrestricted_movement(square)
    |> Bitboard.except(Position.pieces(position, side))
  end

  defp unrestricted_movement(%Square{} = square) do
    IO.inspect(square)
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(8), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_right(7), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_right(1), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_left(8), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_left(9), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), File.file(:h))
    |> conditional_union(bitboard |> Bitboard.shift_left(1), File.file(:a))
  end
end
