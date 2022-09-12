defmodule Game.Parsers.PgnParser do
  import NimbleParsec

  left_bracket = string("[")
  right_bracket = string("]")

  space = ascii_string([?\s, ?\t], min: 1)
  newline = ascii_string([?\r, ?\n], min: 1)
  space_and_newline = choice([space, newline])
  digit = ascii_string([?0..?9], min: 1)

  identifier =
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)

  tag_name = identifier
  tag_value = ascii_string([not: 93..93], min: 1)

  tag =
    tag_name |> unwrap_and_tag(:name)
    |> ignore(repeat(space))
    |> concat(tag_value |> unwrap_and_tag(:value))

  tag_pair =
    left_bracket |> ignore()
    |> concat(tag) |> tag(:tag)
    |> concat(right_bracket |> ignore())

  move_number = digit |> unwrap_and_tag(:move_number) |> ignore(ascii_string([?.] ,min: 0) )
  movetext = optional(move_number) |> tag(:movetext) |> ignore(repeat(space_and_newline))

  pgn =
    repeat(space_and_newline)
    |> concat(tag_pair) |> repeat()
    |> concat(space_and_newline |> repeat())
    |> concat(movetext)

  defparsec(:parse, pgn)
end
