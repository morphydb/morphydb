defmodule MorphyDb.Parsers.FenParser do
  alias MorphyDb.Position
  alias MorphyDb.Bitboard

  import NimbleParsec

  initialize = empty() |> post_traverse(:initializer)
  whitespace = string(" ") |> ignore()
  black_piece = ascii_char([?p, ?n, ?b, ?r, ?q, ?k])
  white_piece = ascii_char([?P, ?N, ?B, ?R, ?Q, ?K])

  digit_1_7 =
    ascii_char([?1..?7])
    |> post_traverse(:duplicate_nil_piece)

  digit_8 =
    ascii_char([?8])
    |> post_traverse(:duplicate_nil_piece)

  piece =
    choice([white_piece, black_piece])
    |> post_traverse(:piece_placement)

  rank =
    choice([
      optional(digit_1_7)
      |> concat(piece)
      |> concat(optional(digit_1_7))
      |> times(min: 1, max: 8),
      digit_8
    ])

  piece_placement =
    rank
    |> concat(ignore(ascii_char([?/])))
    |> times(7)
    |> concat(rank)

  ep_square = ascii_char([?a..?h]) |> concat(ascii_char([?3, ?6]))

  en_passant_target_square =
    choice([ascii_char([?-]), ep_square])
    |> post_traverse(:en_passant)

  side_to_move =
    ascii_char([?w, ?b])
    |> post_traverse(:side_to_move)

  castling_ability =
    ascii_char([?K, ?Q, ?k, ?q, ?-])
    |> post_traverse(:castling_ability)
    |> times(min: 1, max: 4)

  half_move_counter = integer(min: 1) |> post_traverse(:half_move_counter)
  full_move_counter = integer(min: 1) |> post_traverse(:full_move_counter)

  position =
    piece_placement
    |> concat(whitespace)
    |> concat(side_to_move)
    |> concat(whitespace)
    |> concat(castling_ability)
    |> concat(whitespace)
    |> concat(en_passant_target_square)
    |> concat(
      optional(
        empty()
        |> concat(whitespace)
        |> concat(half_move_counter)
        |> concat(whitespace)
        |> concat(full_move_counter)
      )
    )
    |> eos()

  defparsec(:fen, concat(initialize, position))

  defp initializer(fen, _value, _context = %{}, _, _) do
    {[], %Position{fen: fen}}
  end

  defp next_square(rank, file), do: next_square(rank, file, 1)

  defp next_square(rank, file, amount) do
    square = 8 * rank + file

    next_f = file + amount
    next_r = rank - div(next_f, 8)

    %{:current => square, :rank => next_r, :file => rem(next_f, 8)}
  end

  defp duplicate_nil_piece(
         _rest,
         value,
         context = %Position{rank: rank, file: file},
         _line,
         _offset
       ) do
    amount = String.to_integer(to_string(value))
    square = next_square(rank, file, amount)

    {[], %{context | rank: square.rank, file: square.file}}
  end

  defp piece_placement(
         _,
         value,
         context = %Position{
           pieces: pieces,
           all_pieces: all_pieces,
           rank: rank,
           file: file
         },
         _line,
         _offset
       ) do
    square = next_square(rank, file)

    piece = value |> map_piece()
    bitboard = pieces[piece] |> Bitboard.set_bit(square.current)
    {side, _} = piece

    side_bitboard = all_pieces[side] |> Bitboard.set_bit(square.current)

    updated_pieces = %{pieces | piece => bitboard}
    updated_all_pieces = %{all_pieces | side => side_bitboard}

    {[],
     %{
       context
       | pieces: updated_pieces,
         all_pieces: updated_all_pieces,
         rank: square.rank,
         file: square.file
     }}
  end

  defp side_to_move(_, [?b], context = %Position{}, _, _) do
    {[], %{context | side_to_move: :b}}
  end

  defp side_to_move(_, [?w], context = %Position{}, _, _) do
    {[], %{context | side_to_move: :w}}
  end

  defp en_passant(_, '-', context = %Position{}, _, _) do
    {[], %{context | en_passant: nil}}
  end

  defp en_passant(_rest, value, context = %Position{}, _, _) do
    {[], %{context | en_passant: Enum.reverse(value)}}
  end

  defp castling_ability(
         _rest,
         value,
         context = %Position{castling_ability: castling_ability},
         _,
         _
       ) do
    side = value |> Enum.map(&map_castling_ability/1)
    updated = [castling_ability | side]

    {[], %{context | castling_ability: updated}}
  end

  defp half_move_counter(_rest, [value], context = %Position{}, _, _) do
    {[], %{context | half_move_counter: value}}
  end

  defp full_move_counter(_rest, [value], context = %Position{}, _, _) do
    {[], %{context | full_move_counter: value}}
  end

  defp map_castling_ability(?K), do: {:w, :k}
  defp map_castling_ability(?Q), do: {:w, :q}
  defp map_castling_ability(?k), do: {:b, :k}
  defp map_castling_ability(?q), do: {:b, :q}
  defp map_castling_ability(?-), do: nil

  defp map_piece('K'), do: {:w, :k}
  defp map_piece('Q'), do: {:w, :q}
  defp map_piece('R'), do: {:w, :r}
  defp map_piece('B'), do: {:w, :b}
  defp map_piece('N'), do: {:w, :n}
  defp map_piece('P'), do: {:w, :p}

  defp map_piece('k'), do: {:b, :k}
  defp map_piece('q'), do: {:b, :q}
  defp map_piece('r'), do: {:b, :r}
  defp map_piece('b'), do: {:b, :b}
  defp map_piece('n'), do: {:b, :n}
  defp map_piece('p'), do: {:b, :p}
end
