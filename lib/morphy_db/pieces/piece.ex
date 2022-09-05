defmodule MorphyDb.Pieces.Piece do
  defstruct []

  defmacro conditional_union(bitboard, union, except \\ MorphyDb.Bitboard.empty) do
    quote do
      if not MorphyDb.Bitboard.intersects?(unquote(union), unquote(except)) do
        unquote(bitboard) |> MorphyDb.Bitboard.union(unquote(union))
      else
        unquote(bitboard)
      end
    end
  end

  defmodule Attacks do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

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
