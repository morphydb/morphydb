defmodule MorphyDb.Pieces.Piece do
  defmacro conditional_union(attacks, bitboard, except \\ MorphyDb.Bitboard.empty) do
    quote do
      if not MorphyDb.Bitboard.intersects?(unquote(bitboard), unquote(except)) do
        unquote(attacks) |> MorphyDb.Bitboard.union(unquote(bitboard))
      else
        unquote(attacks)
      end
    end
  end

  defmodule Attacks do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

    def mask(:p, position, square_index, color),
      do: Pawn.attack_mask(position, square_index, color)

    def mask(:n, position, square_index, color),
      do: Knight.attack_mask(position, square_index, color)

    def mask(:b, position, square_index, color),
      do: Bishop.attack_mask(position, square_index, color)

    def mask(:r, position, square_index, color),
      do: Rook.attack_mask(position, square_index, color)

    def mask(:q, position, square_index, color),
      do: Queen.attack_mask(position, square_index, color)

    def mask(:k, position, square_index, color),
      do: King.attack_mask(position, square_index, color)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end

  defmodule Moves do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}

    def mask(:p, position, square_index, color), do: Pawn.move_mask(position, square_index, color)

    def mask(:n, position, square_index, color),
      do: Knight.move_mask(position, square_index, color)

    def mask(:b, position, square_index, color),
      do: Bishop.move_mask(position, square_index, color)

    def mask(:r, position, square_index, color), do: Rook.move_mask(position, square_index, color)

    def mask(:q, position, square_index, color),
      do: Queen.move_mask(position, square_index, color)

    def mask(:k, position, square_index, color), do: King.move_mask(position, square_index, color)

    def mask(_, _, _, _), do: MorphyDb.Bitboard.empty()
  end
end
