defmodule MorphyDb.Pieces.Pawn do
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Pieces.Piece.Attacks

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) ::
          MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_left(9), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_left(7), File.file(:h))
    |> Attacks.filter_friendly(position, :w)
    |> en_passant(position, square, :w)
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    bitboard = Square.to_bitboard(square)

    Bitboard.empty()
    |> conditional_union(bitboard |> Bitboard.shift_right(7), File.file(:a))
    |> conditional_union(bitboard |> Bitboard.shift_right(9), File.file(:h))
    |> Attacks.filter_friendly(position, :b)
    |> en_passant(position, square, :b)
  end

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) ::
          MorphyDb.Bitboard.t()
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

  defp en_passant(
         %Bitboard{} = attacks,
         %Position{en_passant: en_passant},
         %Square{} = square,
         side
       ) do

    bitboard = Square.to_bitboard(en_passant)

    file_index = File.to_integer(square.file)
    ep_file_index = File.to_integer(en_passant.file)

    match = {side, en_passant.rank, ep_file_index, file_index}

    to_union =
      cond do
        {:w, 5, ep_file_index, ep_file_index - 1} == match -> bitboard
        {:w, 5, ep_file_index, ep_file_index + 1} == match -> bitboard
        {:b, 2, ep_file_index, ep_file_index - 1} == match -> bitboard
        {:b, 2, ep_file_index, ep_file_index + 1} == match -> bitboard
        true -> Bitboard.empty()
      end

    attacks |> Bitboard.union(to_union)
  end
end
