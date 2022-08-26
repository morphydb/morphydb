defmodule MorphyDb.Pieces.Pawn do
  import MorphyDb.Guards
  import MorphyDb.Pieces.Piece

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position
  alias MorphyDb.Square

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, color) when is_square(square_index) and is_side(color) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    case color do
      :b ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Bitboard.shift_right(7), Board.file(0))
        |> calculate_attacks(bitboard |> Bitboard.shift_right(9), Board.file(7))
        |> Bitboard.intersect(all_pieces[:w])

      :w ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Bitboard.shift_left(9), Board.file(0))
        |> calculate_attacks(bitboard |> Bitboard.shift_left(7), Board.file(7))
        |> Bitboard.intersect(all_pieces[:b])
    end
  end

  def move_mask(square_index, side) when is_square(square_index) and is_side(side) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)
    {_, rank_index} = Square.from_square_index(square_index)

    case side do
      :b ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Board.down())
        |> initial_square(bitboard, rank_index, :b)
        |> Bitboard.unset(square_index)

      :w ->
        Bitboard.empty()
        |> calculate_attacks(bitboard |> Board.up())
        |> initial_square(bitboard, rank_index, :w)
        |> Bitboard.unset(square_index)
    end
  end

  defp initial_square(attacks, bitboard, 6, :b) do
    attacks |> calculate_attacks(bitboard |> Board.down() |> Board.down())
  end

  defp initial_square(attacks, bitboard, 1, :w) do
    attacks |> calculate_attacks(bitboard |> Board.up() |> Board.up())
  end

  defp initial_square(attacks, _, _, _) do
    attacks
  end
end
