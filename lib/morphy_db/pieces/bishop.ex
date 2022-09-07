defmodule MorphyDb.Pieces.Bishop do
  alias MorphyDb.Bitboard
  alias MorphyDb.File
  alias MorphyDb.Square
  alias MorphyDb.Position
  alias MorphyDb.Pieces.Piece.Blocked
  alias MorphyDb.Pieces.Piece.Attacks

  @spec attack_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def attack_mask(%Position{} = position, %Square{} = square, side), do:
    mask(position, square)
    |> Attacks.filter_friendly(position, side)

  @spec move_mask(MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def move_mask(%Position{} = position, %Square{} = square, side), do:
    mask(position, square)
    |> Bitboard.except(Position.pieces(position, side))

  defp mask(%Position{} = position, %Square{file: file, rank: rank}) do
    all_pieces = Position.all_pieces(position)
    file_index = File.to_integer(file)

    top_right =
      (file_index + 1)..7//1 |> Enum.map(fn f -> File.to_file(f) end)
      |> Enum.zip((rank + 1)..7//1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    bottom_right =
      (file_index + 1)..7//1 |> Enum.map(fn f -> File.to_file(f) end)
      |> Enum.zip((rank - 1)..0//-1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    top_left =
      (file_index - 1)..0//-1 |> Enum.map(fn f -> File.to_file(f) end)
      |> Enum.zip((rank + 1)..7//1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    bottom_left =
      (file_index - 1)..0//-1 |> Enum.map(fn f -> File.to_file(f) end)
      |> Enum.zip((rank - 1)..0//-1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    top_right
    |> Bitboard.union(bottom_right)
    |> Bitboard.union(top_left)
    |> Bitboard.union(bottom_left)
  end
end
