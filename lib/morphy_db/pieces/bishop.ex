defmodule MorphyDb.Pieces.Bishop do
  defstruct []

  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position
  alias MorphyDb.Pieces.Piece.Blocked
  alias MorphyDb.Pieces.Piece.Attacks

  def attack_mask(%Position{} = position, %Square{} = square, :w), do:
    mask(position, square)
    |> Attacks.filter_friendly(position, :w)

  def attack_mask(%Position{} = position, %Square{} = square, :b), do:
    mask(position, square)
    |> Attacks.filter_friendly(position, :b)

  def move_mask(%Position{} = position, %Square{} = square, side), do: mask(position, square) |> Bitboard.except(Position.pieces(position, side))

  defp mask(%Position{} = position, %Square{rank: rank, file: file}) do
    all_pieces = Position.all_pieces(position)

    top_right =
      (file + 1)..7//1 |> Enum.zip((rank + 1)..7//1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    bottom_right =
      (file + 1)..7//1 |> Enum.zip((rank - 1)..0//-1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    top_left =
      (file - 1)..0//-1 |> Enum.zip((rank + 1)..7//1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    bottom_left =
      (file - 1)..0//-1 |> Enum.zip((rank - 1)..0//-1)
      |> Enum.map(fn {f, r} -> Square.new(f, r) end)
      |> Blocked.mask_movement(all_pieces)

    top_right
    |> Bitboard.union(bottom_right)
    |> Bitboard.union(top_left)
    |> Bitboard.union(bottom_left)
  end
end
