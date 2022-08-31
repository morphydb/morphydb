defmodule MorphyDb.Pieces.Bishop do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

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

  def unrestricted_movement(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    max_to_tr = min(7 - file_index, 7 - rank_index)
    max_to_tl = min(file_index, 7 - rank_index)
    max_to_br = min(7 - file_index, rank_index)
    max_to_bl = min(file_index, rank_index)

    tl =
      1..max_to_tl//1
      |> Enum.map(fn index -> Square.to_square_index(file_index - index, rank_index + index) end)

    tr =
      1..max_to_tr//1
      |> Enum.map(fn index -> Square.to_square_index(file_index + index, rank_index + index) end)

    bl =
      1..max_to_bl//1
      |> Enum.map(fn index -> Square.to_square_index(file_index - index, rank_index - index) end)

    br =
      1..max_to_br//1
      |> Enum.map(fn index -> Square.to_square_index(file_index + index, rank_index - index) end)

    (tl ++ tr ++ bl ++ br)
    |> Enum.reduce(Bitboard.empty(), fn square, b -> Bitboard.set_bit(b, square) end)
  end
end
