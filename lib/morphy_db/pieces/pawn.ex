defmodule MorphyDb.Pieces.Pawn do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position
  alias MorphyDb.Square

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, :b)
      when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(7), Board.file(0))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), Board.file(7))
    |> Bitboard.intersect(all_pieces[:w])
  end

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, :w)
      when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_left(9), Board.file(7))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), Board.file(0))
    |> Bitboard.intersect(all_pieces[:b])
  end

  def move_mask(position, square_index, :w) when is_square(square_index) do
    {_, rank_index} = Square.from_square_index(square_index)

    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_left(8))
    |> initial_square(bitboard, rank_index, :w)
    |> Bitboard.except(position.all_pieces.all)
  end

  def move_mask(position, square_index, :b) when is_square(square_index) do
    {_, rank_index} = Square.from_square_index(square_index)

    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Bitboard.shift_right(8))
    |> initial_square(bitboard, rank_index, :b)
    |> Bitboard.except(position.all_pieces.all)
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
