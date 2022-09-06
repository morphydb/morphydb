defmodule MorphyDb.Pieces.Piece do
  defstruct []

  defmacro conditional_union(bitboard, union, except \\ MorphyDb.Bitboard.empty()) do
    quote do
      if not MorphyDb.Bitboard.intersects?(unquote(union), unquote(except)) do
        unquote(bitboard) |> MorphyDb.Bitboard.union(unquote(union))
      else
        unquote(bitboard)
      end
    end
  end

  defmodule Blocked do
    alias MorphyDb.Bitboard
    alias MorphyDb.Square

    def mask_movement(squares, %Bitboard{} = all_pieces) do
      squares
      |> Enum.map(fn square -> Square.to_bitboard(square) end)
      |> Enum.reduce_while(Bitboard.empty(), fn bitboard, result ->
        union = Bitboard.union(result, bitboard)
        if Bitboard.intersects?(union, all_pieces), do: {:halt, union}, else: {:cont, union}
      end)
    end

  end

  defmodule Attacks do
    alias MorphyDb.Bitboard
    alias MorphyDb.Position
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

    def filter_friendly(%Bitboard{} = bitboard, %Position{} = position, :w), do:
      bitboard
      |> Bitboard.except(Position.white_pieces(position))
      |> Bitboard.intersect(Position.black_pieces(position))

    def filter_friendly(%Bitboard{} = bitboard, %Position{} = position, :b), do:
      bitboard
      |> Bitboard.except(Position.black_pieces(position))
      |> Bitboard.intersect(Position.white_pieces(position))

    def mask(:p, position, square, side),
      do: Pawn.attack_mask(position, square, side)

    def mask(:n, position, square, side),
      do: Knight.attack_mask(position, square, side)

    def mask(:b, position, square, side),
      do: Bishop.attack_mask(position, square, side)

    def mask(:r, position, square, side),
      do: Rook.attack_mask(position, square, side)

    def mask(:q, position, square, side),
      do: Queen.attack_mask(position, square, side)

    def mask(:k, position, square, side),
      do: King.attack_mask(position, square, side)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end

  defmodule Moves do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

    def mask(:p, position, square, side), do: Pawn.move_mask(position, square, side)

    def mask(:n, position, square, side),
      do: Knight.move_mask(position, square, side)

    def mask(:b, position, square, side),
      do: Bishop.move_mask(position, square, side)

    def mask(:r, position, square, side), do: Rook.move_mask(position, square, side)

    def mask(:q, position, square, side),
      do: Queen.move_mask(position, square, side)

    def mask(:k, position, square, side), do: King.move_mask(position, square, side)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end
end
