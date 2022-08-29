defmodule MorphyDb.Pieces.Knight do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position

  def attack_mask(position = %Position{all_pieces: all_pieces}, square_index, :w)
      when is_square(square_index) do
    move_mask(position, square_index, :w)
    |> Bitboard.intersect(all_pieces[:b])
  end

  def attack_mask(position = %Position{all_pieces: all_pieces}, square_index, :b)
      when is_square(square_index) do
    move_mask(position, square_index, :b)
    |> Bitboard.intersect(all_pieces[:w])
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    Bitboard.empty()
    |> Bitboard.union(bitboard |> move_down_left(2, 1))
    |> Bitboard.union(bitboard |> move_down_left(1, 2))
    |> Bitboard.union(bitboard |> move_down_right(1, 2))
    |> Bitboard.union(bitboard |> move_down_right(2, 1))
    |> Bitboard.union(bitboard |> move_up_left(2, 1))
    |> Bitboard.union(bitboard |> move_up_left(1, 2))
    |> Bitboard.union(bitboard |> move_up_right(1, 2))
    |> Bitboard.union(bitboard |> move_up_right(2, 1))
    |> Bitboard.except(position.all_pieces[color])
  end

  defp move_down_left(bitboard, down, left),
    do:
      bitboard
      |> Board.down(down)
      |> Board.left(left)
      |> Bitboard.except(Board.file(6))
      |> Bitboard.except(Board.file(7))

  defp move_down_right(bitboard, down, right),
    do:
      bitboard
      |> Board.down(down)
      |> Board.right(right)
      |> Bitboard.except(Board.file(0))
      |> Bitboard.except(Board.file(1))

  defp move_up_left(bitboard, up, left),
    do:
      bitboard
      |> Board.up(up)
      |> Board.left(left)
      |> Bitboard.except(Board.file(6))
      |> Bitboard.except(Board.file(7))

  defp move_up_right(bitboard, up, right),
    do:
      bitboard
      |> Board.up(up)
      |> Board.right(right)
      |> Bitboard.except(Board.file(0))
      |> Bitboard.except(Board.file(1))
end
