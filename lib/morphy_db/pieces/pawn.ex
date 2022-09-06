defmodule MorphyDb.Pieces.Pawn do
  defstruct []

  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Pieces.Piece.Attacks

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_left(9), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), File.file(7))
    |> Attacks.filter_friendly(position, :w)
    |> en_passant(position, square, :w)
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(7), File.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), File.file(7))
    |> Attacks.filter_friendly(position, :b)
    |> en_passant(position, square, :b)
  end

  def move_mask(%Position{} = position, %Square{rank: rank} = square, :w) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_left(8))
    |> initial_square(bitboard, rank, position, :w)
    |> Bitboard.except(Position.all_pieces(position))
  end

  def move_mask(%Position{} = position, %Square{rank: rank} = square, :b) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_right(8))
    |> initial_square(bitboard, rank, position, :b)
    |> Bitboard.except(Position.all_pieces(position))
  end

  defp initial_square(attacks, bitboard, 6, %Position{} = position, :b) do
    attacks
    |> conditional_union(bitboard |> Bitboard.shift_right(16), Position.all_pieces(position))
  end

  defp initial_square(attacks, bitboard, 1, %Position{} = position, :w) do
    attacks
    |> conditional_union(bitboard |> Bitboard.shift_left(16), Position.all_pieces(position))
  end

  defp initial_square(attacks, _, _, _, _) do
    attacks
  end

  defp en_passant(%Bitboard{} = attacks, %Position{en_passant: ep_square}, %Square{} = square, :w)
    when ep_square.rank === 5 and ep_square.file === square.file - 1 do

    attacks |> Bitboard.union(Square.to_bitboard(square) |> Bitboard.shift_left(7))
  end

  defp en_passant(%Bitboard{} = attacks, %Position{en_passant: ep_square}, %Square{} = square, :w)
    when ep_square.rank === 5 and ep_square.file === square.file + 1 do

    attacks |> Bitboard.union(Square.to_bitboard(square) |> Bitboard.shift_left(9))
  end

  defp en_passant(%Bitboard{} = attacks, %Position{en_passant: ep_square}, %Square{} = square, :b)
    when ep_square.rank === 2 and ep_square.file === square.file - 1 do

    attacks |> Bitboard.union(Square.to_bitboard(square) |> Bitboard.shift_right(9))
  end

  defp en_passant(%Bitboard{} = attacks, %Position{en_passant: ep_square}, %Square{} = square, :b)
    when ep_square.rank === 2 and ep_square.file === square.file + 1 do

    attacks |> Bitboard.union(Square.to_bitboard(square) |> Bitboard.shift_right(7))
  end

  defp en_passant(%Bitboard{} = attacks, %Position{en_passant: ep_square}, %Square{} = square, _side) do
    IO.inspect(ep_square)
    IO.inspect(square)

    attacks
  end
end
