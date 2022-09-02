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

    def mask(:p, position, square_index, side),
      do: Pawn.attack_mask(position, square_index, side)

    def mask(:n, position, square_index, side),
      do: Knight.attack_mask(position, square_index, side)

    def mask(:b, position, square_index, side),
      do: Bishop.attack_mask(position, square_index, side)

    def mask(:r, position, square_index, side),
      do: Rook.attack_mask(position, square_index, side)

    def mask(:q, position, square_index, side),
      do: Queen.attack_mask(position, square_index, side)

    def mask(:k, position, square_index, side),
      do: King.attack_mask(position, square_index, side)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end

  defmodule Moves do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

    def mask(:p, position, square_index, side), do: Pawn.move_mask(position, square_index, side)

    def mask(:n, position, square_index, side),
      do: Knight.move_mask(position, square_index, side)

    def mask(:b, position, square_index, side),
      do: Bishop.move_mask(position, square_index, side)

    def mask(:r, position, square_index, side), do: Rook.move_mask(position, square_index, side)

    def mask(:q, position, square_index, side),
      do: Queen.move_mask(position, square_index, side)

    def mask(:k, position, square_index, side), do: King.move_mask(position, square_index, side)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end
end
