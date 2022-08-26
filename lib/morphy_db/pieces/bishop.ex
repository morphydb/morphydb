defmodule MorphyDb.Pieces.Bishop do
  import MorphyDb.Guards

  alias MorphyDb.Bitboard
  alias MorphyDb.Board
  alias MorphyDb.Position
  alias MorphyDb.Square

  def attack_mask(%Position{all_pieces: all_pieces}, square_index, color) when is_square(square_index) and is_side(color) do
    move_mask(square_index)
    |> Bitboard.intersect(all_pieces[(if color === :w, do: :b, else: :w)])
  end

  def move_mask(square_index) when is_square(square_index) do
    {file_index, rank_index} = Square.from_square_index(square_index)

    bitboard = Bitboard.empty() |> Bitboard.set_bit(square_index)

    max_to_tr = min(7 - file_index, 7 - rank_index)
    max_to_tl = min(file_index, 7 - rank_index)
    max_to_br = min(7 - file_index, rank_index)
    max_to_bl = min(file_index, rank_index)

    tr =
      0..max_to_tr
      |> Enum.reduce(Bitboard.empty(), fn i, b -> Bitboard.union(b, bitboard |> Board.up(i) |> Board.right(i)) end)

    tl =
      0..max_to_tl
      |> Enum.reduce(Bitboard.empty(), fn i, b -> Bitboard.union(b, bitboard |> Board.up(i) |> Board.left(i)) end)

    br =
      0..max_to_br
      |> Enum.reduce(Bitboard.empty(), fn i, b -> Bitboard.union(b, bitboard |> Board.down(i) |> Board.right(i)) end)

    bl =
      0..max_to_bl
      |> Enum.reduce(Bitboard.empty(), fn i, b -> Bitboard.union(b, bitboard |> Board.down(i) |> Board.left(i)) end)

    Bitboard.empty()
      |> Bitboard.union(tl)
      |> Bitboard.union(tr)
      |> Bitboard.union(bl)
      |> Bitboard.union(br)
      |> Bitboard.unset(square_index)
  end
end
