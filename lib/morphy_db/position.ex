defmodule MorphyDb.Position do
  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Parsers.FenParser
  alias MorphyDb.Side
  alias MorphyDb.Pieces.Piece

  @type t() :: %__MODULE__{
    fen: String.t(),
    side_to_move: Side.t(),
    en_passant: Square.t(),
    half_move_counter: integer(),
    full_move_counter: integer(),
    castling_ability: [{Side.t(), Piece.t()}],
    pieces: %{
      {Side.t(), Piece.t()} => Bitboard.t()
    }
  }

  defstruct [
    :fen,
    :side_to_move,
    :en_passant,
    :half_move_counter,
    :full_move_counter,
    castling_ability: [],
    pieces: %{
      {:w, :p} => Bitboard.empty(),
      {:w, :r} => Bitboard.empty(),
      {:w, :n} => Bitboard.empty(),
      {:w, :b} => Bitboard.empty(),
      {:w, :k} => Bitboard.empty(),
      {:w, :q} => Bitboard.empty(),
      {:b, :p} => Bitboard.empty(),
      {:b, :r} => Bitboard.empty(),
      {:b, :n} => Bitboard.empty(),
      {:b, :b} => Bitboard.empty(),
      {:b, :k} => Bitboard.empty(),
      {:b, :q} => Bitboard.empty()
    },
    rank: 7,
    file: 0
  ]

  @spec parse(String.t()) :: {:error, :invalid_fen} | {:ok, t()}
  def parse(fen) when is_bitstring(fen) do
    case FenParser.fen(fen |> String.trim()) do
      {:ok, _, _, position, _, _} -> {:ok, position}
      _ -> {:error, :invalid_fen}
    end
  end

  @spec piece(MorphyDb.Position.t(), MorphyDb.Square.t()) :: {any, any}
  def piece(%MorphyDb.Position{pieces: pieces}, %Square{} = square) do
    case Enum.filter(pieces, fn {_piece, bitboard} -> Bitboard.is_set?(bitboard, Square.to_index(square)) end) do
      [{{side, piece}, _bitboard}] -> {side, piece}
      [] -> {nil, nil}
    end
  end

  @spec white_pieces(MorphyDb.Position.t()) :: MorphyDb.Bitboard.t()
  def white_pieces(%MorphyDb.Position{} = position), do: pieces(position, :w)

  @spec black_pieces(MorphyDb.Position.t()) :: MorphyDb.Bitboard.t()
  def black_pieces(%MorphyDb.Position{} = position), do: pieces(position, :b)

  @spec all_pieces(MorphyDb.Position.t()) :: MorphyDb.Bitboard.t()
  def all_pieces(%MorphyDb.Position{} = position), do: white_pieces(position) |> Bitboard.union(black_pieces(position))

  @spec pieces(MorphyDb.Position.t(), MorphyDb.Side.t()) :: MorphyDb.Bitboard.t()
  def pieces(%MorphyDb.Position{pieces: pieces}, side) do
    pieces
    |> Map.filter(fn {{color, _}, _} -> color == side end)
    |> Map.values()
    |> List.foldl(Bitboard.empty(), fn board, acc -> Bitboard.union(board, acc) end)
  end
end
