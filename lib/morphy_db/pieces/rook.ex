defmodule MorphyDb.Pieces.Rook do
  defstruct []

  alias MorphyDb.Bitboard
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Position

  alias MorphyDb.Pieces.Piece.Blocked
  alias MorphyDb.Pieces.Piece.Attacks

  def attack_mask(%Position{} = position, %Square{} = square, :w),
    do:
      mask(position, square)
      |> Attacks.filter_friendly(position, :w)

  def attack_mask(%Position{} = position, %Square{} = square, :b),
    do:
      mask(position, square)
      |> Attacks.filter_friendly(position, :b)

  def move_mask(%Position{} = position, %Square{} = square, :w), do: mask(position, square) |> Bitboard.except(Position.white_pieces(position))
  def move_mask(%Position{} = position, %Square{} = square, :b), do: mask(position, square) |> Bitboard.except(Position.black_pieces(position))

  defp mask(%Position{} = position, %Square{rank: rank, file: file}) do
    all_pieces = Position.all_pieces(position)

    inc_file =
      (file + 1)..7//1
      |> Enum.map(fn f -> Square.new(f, rank) end)
      |> Blocked.mask_movement(all_pieces)

    inc_rank =
      (rank + 1)..7//1
      |> Enum.map(fn r -> Square.new(file, r) end)
      |> Blocked.mask_movement(all_pieces)

    dec_file =
      (file - 1)..0//-1
      |> Enum.map(fn f -> Square.new(f, rank) end)
      |> Blocked.mask_movement(all_pieces)

    dec_rank =
      (rank - 1)..0//-1
      |> Enum.map(fn r -> Square.new(file, r) end)
      |> Blocked.mask_movement(all_pieces)

    inc_file
    |> Bitboard.union(inc_rank)
    |> Bitboard.union(dec_file)
    |> Bitboard.union(dec_rank)
  end
end
