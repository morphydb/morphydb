defmodule MorphyDb.Pieces.Bishop do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Square

  def attack_mask(position, square_index, :w) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:b])
  end

  def attack_mask(position, square_index, :b) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.intersect(position.all_pieces[:w])
  end

  def move_mask(position, square_index, color) when is_square(square_index) do
    unrestricted_movement(square_index)
    |> Bitboard.except(position.all_pieces.all)
    |> Bitboard.union(attack_mask(position, square_index, color))
  end

  defp unrestricted_movement(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    max_to_tr = min(7 - file_index, 7 - rank_index)
    max_to_tl = min(file_index, 7 - rank_index)
    max_to_br = min(7 - file_index, rank_index)
    max_to_bl = min(file_index, rank_index)

    tr =
      0..max_to_tr
      |> Enum.reduce(Bitboard.empty(), fn i, b ->
        Bitboard.union(b, bitboard |> Board.up(i) |> Board.right(i))
      end)

    tl =
      0..max_to_tl
      |> Enum.reduce(Bitboard.empty(), fn i, b ->
        Bitboard.union(b, bitboard |> Board.up(i) |> Board.left(i))
      end)

    br =
      0..max_to_br
      |> Enum.reduce(Bitboard.empty(), fn i, b ->
        Bitboard.union(b, bitboard |> Board.down(i) |> Board.right(i))
      end)

    bl =
      0..max_to_bl
      |> Enum.reduce(Bitboard.empty(), fn i, b ->
        Bitboard.union(b, bitboard |> Board.down(i) |> Board.left(i))
      end)

    Bitboard.empty()
    |> Bitboard.union(tl)
    |> Bitboard.union(tr)
    |> Bitboard.union(bl)
    |> Bitboard.union(br)
  end
end
