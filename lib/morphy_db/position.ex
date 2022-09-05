defmodule MorphyDb.Position do
  alias MorphyDb.Bitboard
  alias MorphyDb.Square
  alias MorphyDb.Parsers.FenParser

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
    all_pieces: %{
      :w => Bitboard.empty(),
      :b => Bitboard.empty()
    },
    rank: 7,
    file: 0
  ]

  def parse(fen) when is_bitstring(fen) do
    case FenParser.fen(fen |> String.trim()) do
      {:ok, _, _, position, _, _} -> {:ok, position}
      _ -> {:error, :invalid_fen}
    end
  end

  def piece(%MorphyDb.Position{pieces: pieces}, %Square{index: square}) do
    case Enum.filter(pieces, fn {_piece, bitboard} -> Bitboard.is_set?(bitboard, square) end) do
      [{{side, piece}, _bitboard}] -> {side, piece}
      [] -> {nil, nil}
    end
  end
end
