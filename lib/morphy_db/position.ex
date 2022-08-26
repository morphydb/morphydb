defmodule MorphyDb.Position do
  alias MorphyDb.Bitboard
  alias MorphyDb.Parsers.FenParser
  import MorphyDb.Guards

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
    rank_index: 7,
    file_index: 0
  ]

  def parse(fen) when is_bitstring(fen) do
    {:ok, _, _, position, _, _} = FenParser.fen(fen |> String.trim())

    position
  end

  def piece(%MorphyDb.Position{pieces: pieces}, square_index) when is_square(square_index) do
    case Enum.filter(pieces, fn {_piece, bitboard} -> Bitboard.is_set(bitboard, square_index) end) do
      [{k, _v}] -> k
      [] -> nil
    end
  end
end
