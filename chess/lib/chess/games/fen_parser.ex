defmodule Chess.Games.FenParser do
  alias Chess.Bitboard
  alias Chess.Games.Position
  alias Chess.Games.Square

  def parse!(fen) do
    {:ok, position} = parse(fen)
    position
  end

  def parse(fen) do
    [piece_placement, active_color, castling_ability, en_passant, halfmove_clock, fullmove_number] =
      String.split(fen, " ")

    position = parse_piece_placement(piece_placement)

    {:ok,
     %Position{
       position: position,
       bitboards: calculate_bitboards(position),
       active_color: parse_active_color(active_color),
       castling_ability: parse_castling_ability(castling_ability),
       en_passant: parse_en_passant(en_passant),
       halfmove_clock: parse_halfmove_clock(halfmove_clock),
       fullmove_number: parse_fullmove_number(fullmove_number),
       highlight: Bitboard.empty(),
       highlight_alt: Bitboard.empty(),
       highlight_ctrl: Bitboard.empty(),
       arrows: []
     }}
  end

  defp parse_piece_placement(piece_placement),
    do:
      piece_placement
      |> String.split("/")
      |> Enum.map(fn row -> parse_row(row) end)

  defp parse_row(row),
    do:
      row
      |> String.split("", trim: true)
      |> Enum.reverse()
      |> Enum.flat_map(fn square -> parse_square(square) end)

  defp parse_square(piece)
       when piece in ["P", "N", "B", "R", "Q", "K", "p", "n", "b", "r", "q", "k"],
       do: [String.to_existing_atom(piece)]

  defp parse_square(piece), do: List.duplicate(:empty, String.to_integer(piece))

  defp parse_active_color("w"), do: :w
  defp parse_active_color("b"), do: :b

  defp parse_castling_ability("-"), do: []

  defp parse_castling_ability(castling_availability),
    do:
      castling_availability
      |> String.split("", trim: true)
      |> Enum.map(fn p -> String.to_existing_atom(p) end)

  defp parse_en_passant("-"), do: nil

  defp parse_en_passant(en_passant) do
    en_passant
    |> String.split("", trim: true)
    |> (fn [<<file::utf8>>, <<rank::utf8>>] -> Square.new(%{file: file - ?a, rank: rank - ?1}) end).()
  end

  defp parse_halfmove_clock(halfmove_clock), do: String.to_integer(halfmove_clock)

  defp parse_fullmove_number(fullmove_number), do: String.to_integer(fullmove_number)

  defp calculate_bitboards(position),
    do:
      position
      |> List.flatten()
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reduce(
        %{
          P: Bitboard.empty(),
          R: Bitboard.empty(),
          N: Bitboard.empty(),
          B: Bitboard.empty(),
          Q: Bitboard.empty(),
          K: Bitboard.empty(),
          p: Bitboard.empty(),
          r: Bitboard.empty(),
          n: Bitboard.empty(),
          b: Bitboard.empty(),
          q: Bitboard.empty(),
          k: Bitboard.empty()
        },
        fn {piece, square}, bitboards -> bitboards |> calculate_bitboards(square, piece) end
      )

  defp calculate_bitboards(bitboards, _square, :empty), do: bitboards

  defp calculate_bitboards(bitboards, square, piece) do
    Map.update!(bitboards, piece, fn bitboard -> Bitboard.set(bitboard, square) end)
  end
end
