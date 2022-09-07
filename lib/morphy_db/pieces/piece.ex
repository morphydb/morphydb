defmodule MorphyDb.Pieces.Piece do
  @type t() :: :k | :q | :r | :b | :n | :p

  @spec conditional_union(MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t(), MorphyDb.Bitboard.t()) ::MorphyDb.Bitboard.t()
  def conditional_union(bitboard, union, except \\ MorphyDb.Bitboard.empty()) do
    if not MorphyDb.Bitboard.intersects?(union, except) do
      bitboard |> MorphyDb.Bitboard.union(union)
    else
      bitboard
    end
  end

  defmodule Blocked do
    alias MorphyDb.Bitboard
    alias MorphyDb.Square

    @spec mask_movement([MorphyDb.Square.t()], MorphyDb.Bitboard.t()) :: MorphyDb.Bitboard.t()
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

    @spec filter_friendly(MorphyDb.Bitboard.t(), MorphyDb.Position.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
    def filter_friendly(%Bitboard{} = bitboard, %Position{} = position, :w), do:
      bitboard
      |> Bitboard.except(Position.white_pieces(position))
      |> Bitboard.intersect(Position.black_pieces(position))

    def filter_friendly(%Bitboard{} = bitboard, %Position{} = position, :b), do:
      bitboard
      |> Bitboard.except(Position.black_pieces(position))
      |> Bitboard.intersect(Position.white_pieces(position))

    @spec mask(MorphyDb.Pieces.Piece.t(), MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
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

    def mask(_, _, _, _), do: Bitboard.empty()
  end

  defmodule Moves do
    alias MorphyDb.Pieces.{Pawn, Knight, Bishop, Rook, Queen, King}
    alias MorphyDb.Bitboard

    @spec mask(MorphyDb.Pieces.Piece.t(), MorphyDb.Position.t(), MorphyDb.Square.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
    def mask(:p, position, square, side), do: Pawn.move_mask(position, square, side)

    def mask(:n, position, square, side),
      do: Knight.move_mask(position, square, side)

    def mask(:b, position, square, side),
      do: Bishop.move_mask(position, square, side)

    def mask(:r, position, square, side), do: Rook.move_mask(position, square, side)

    def mask(:q, position, square, side),
      do: Queen.move_mask(position, square, side)

    def mask(:k, position, square, side), do: King.move_mask(position, square, side)

    def mask(_, _, _, _), do: Bitboard.empty()
  end
end
