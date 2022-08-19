defmodule MorphyDb.FenParser do
  alias MorphyDb.Position
  alias MorphyDb.Piece

  import NimbleParsec

  initialize = empty() |> post_traverse(:initializer)
  whitespace = string(" ") |> ignore()
  file = ascii_char([?a..?h])
  black_piece = ascii_char([?p, ?n, ?b, ?r, ?q, ?k])
  white_piece = ascii_char([?P, ?N, ?B, ?R, ?Q, ?K])

  digit_1_7 =
    ascii_char([?1..?7])
    |> post_traverse(:duplicate_nil_piece)

  digit_8 =
    ascii_char([?8])
    |> post_traverse(:duplicate_nil_piece)

  piece = choice([white_piece, black_piece])

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
    |> concat(ignore(string("/")))
    |> times(7)
    |> concat(rank)
    |> post_traverse(:piece_placement)

  ep_rank = ascii_char([?3, ?6])
  ep_square = file |> concat(ep_rank)

  en_passant_target_square =
    choice([ascii_char([?-]), ep_square])
    |> post_traverse(:en_passant)

  side_to_move =
    ascii_char([?w, ?b])
    |> post_traverse(:side_to_move)

  castling_ability =
    ascii_char([?K, ?Q, ?k, ?q, ?-])
    |> times(min: 1, max: 4)
    |> post_traverse(:castling_ability)

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
    |> concat(whitespace)
    |> concat(half_move_counter)
    |> concat(whitespace)
    |> concat(full_move_counter)

  defparsec(:fen, concat(initialize, position) |> eos(), debug: true)

  defp map_piece(?K), do: %Piece{color: :white, piece: :king}
  defp map_piece(?Q), do: %Piece{color: :white, piece: :queen}
  defp map_piece(?R), do: %Piece{color: :white, piece: :rook}
  defp map_piece(?B), do: %Piece{color: :white, piece: :bishop}
  defp map_piece(?N), do: %Piece{color: :white, piece: :knight}
  defp map_piece(?P), do: %Piece{color: :white, piece: :pawn}

  defp map_piece(?k), do: %Piece{color: :black, piece: :king}
  defp map_piece(?q), do: %Piece{color: :black, piece: :queen}
  defp map_piece(?r), do: %Piece{color: :black, piece: :rook}
  defp map_piece(?b), do: %Piece{color: :black, piece: :bishop}
  defp map_piece(?n), do: %Piece{color: :black, piece: :knight}
  defp map_piece(?p), do: %Piece{color: :black, piece: :pawn}

  defp map_piece(nil), do: nil

  defp duplicate_nil_piece(_rest, args, context, _line, _offset) do
    amount = String.to_integer(to_string(args))
    result = List.duplicate(nil, amount)
    {result, context}
  end

  defp initializer(fen, _value, _context = %{}, _, _) do
    {[], %Position{fen: fen}}
  end

  defp piece_placement(_, value, context = %Position{}, _, _) do
    {[], %{context | pieces: value |> Enum.map(&map_piece/1)}}
  end

  defp side_to_move(_, [?b], context = %Position{}, _, _) do
    {[], %{context | side_to_move: :black}}
  end

  defp side_to_move(_, [?w], context = %Position{}, _, _) do
    {[], %{context | side_to_move: :white}}
  end

  defp en_passant(_, '-', context = %Position{}, _, _) do
    {[], %{context | en_passant: nil}}
  end

  defp en_passant(_rest, value, context = %Position{}, _, _) do
    {[], %{context | en_passant: Enum.reverse(value)}}
  end

  defp castling_ability(_rest, '-', context = %Position{}, _, _) do
    {[], %{context | castling_ability: nil}}
  end

  defp castling_ability(_rest, value, context = %Position{}, _, _) do
    {[], %{context | castling_ability: Enum.map(value, &map_piece(&1))}}
  end

  defp half_move_counter(_rest, [value], context = %Position{}, _, _) do
    {[], %{context | half_move_counter: value}}
  end

  defp full_move_counter(_rest, [value], context = %Position{}, _, _) do
    {[], %{context | full_move_counter: value}}
  end
end
