defmodule MorphyDb.Pieces.King do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board

  def attack_mask(position, square_index, :w) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(position, square_index, :b) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(position, square_index, side) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, side))
  end

  defp unrestricted_movement(square_index) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> Board.down(1))
    |> Bitboard.union(bitboard |> move_down_left())
    |> Bitboard.union(bitboard |> move_down_right())
    |> Bitboard.union(bitboard |> move_left)
    |> Bitboard.union(bitboard |> Board.up(1))
    |> Bitboard.union(bitboard |> move_up_left)
    |> Bitboard.union(bitboard |> move_up_right)
    |> Bitboard.union(bitboard |> move_right)
    |> Bitboard.unset(square_index)
  end

  defp move_down_left(bitboard),
    do:
      bitboard
      |> Board.down(1)
      |> Board.left(1)
      |> Bitboard.except(Board.file(7))

  defp move_down_right(bitboard),
    do:
      bitboard
      |> Board.down(1)
      |> Board.right(1)
      |> Bitboard.except(Board.file(0))

  defp move_left(bitboard),
    do:
      bitboard
      |> Board.left(1)
      |> Bitboard.except(Board.file(7))

  defp move_right(bitboard),
    do:
      bitboard
      |> Board.right(1)
      |> Bitboard.except(Board.file(0))

  defp move_up_left(bitboard),
    do:
      bitboard
      |> Board.up(1)
      |> Board.left(1)
      |> Bitboard.except(Board.file(7))

  defp move_up_right(bitboard),
    do:
      bitboard
      |> Board.up(1)
      |> Board.right(1)
      |> Bitboard.except(Board.file(0))
end
