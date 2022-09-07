defmodule MorphyDb.Pieces.Rook do
  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.Position

  alias MorphyDb.Pieces.Piece.Blocked
  alias MorphyDb.Pieces.Piece.Attacks

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, :w),
    do:
      mask(position, square)
      |> Attacks.filter_friendly(position, :w)

  def attack_mask(%Position{} = position, %Square{} = square, :b),
    do:
      mask(position, square)
      |> Attacks.filter_friendly(position, :b)

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def move_mask(%Position{} = position, %Square{} = square, side), do: mask(position, square) |> Bitboard.except(Position.pieces(position, side))

  defp mask(%Position{} = position, %Square{file: file, rank: rank}) do
    all_pieces = Position.all_pieces(position)
    file_index = MorphyDb.File.to_integer(file)

    inc_file =
      (file_index + 1)..7//1 |> Enum.map(fn f -> File.to_file(f) end)
      |> Enum.map(fn f -> Square.new(f, rank) end)
      |> Blocked.mask_movement(all_pieces)

    inc_rank =
      (rank + 1)..7//1
      |> Enum.map(fn r -> Square.new(file, r) end)
      |> Blocked.mask_movement(all_pieces)

    dec_file =
      (file_index - 1)..0//-1 |> Enum.map(fn f -> File.to_file(f) end)
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
