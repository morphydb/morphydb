defmodule MorphyDb.Pieces.Bishop do
  defstruct []

  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Position

  def attack_mask(%Position{} = position, %Square{} = square, :w) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(%Position{} = position, %Square{} = square, :b) do
    unrestricted_movement(square)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(%Position{} = position, %Square{} = square, side) do
    unrestricted_movement(square)
    |> Bitboard.except(position.all_pieces[:w])
    |> Bitboard.except(position.all_pieces[:b])
    |> Bitboard.union(attack_mask(position, square, side))
  end

  def unrestricted_movement(%Square{file: file, rank: rank}) do
    max_to_tr = min(7 - file, 7 - rank)
    max_to_tl = min(file, 7 - rank)
    max_to_br = min(7 - file, rank)
    max_to_bl = min(file, rank)

    tl =
      1..max_to_tl//1
      |> Enum.map(fn index -> Square.new(file - index, rank + index) end)

    tr =
      1..max_to_tr//1
      |> Enum.map(fn index -> Square.new(file + index, rank + index) end)

    bl =
      1..max_to_bl//1
      |> Enum.map(fn index -> Square.new(file - index, rank - index) end)

    br =
      1..max_to_br//1
      |> Enum.map(fn index -> Square.new(file + index, rank - index) end)

    (tl ++ tr ++ bl ++ br)
    |> Enum.reduce(Bitboard.empty(), fn square, b -> Bitboard.set_bit(b, square.index) end)
  end
end
