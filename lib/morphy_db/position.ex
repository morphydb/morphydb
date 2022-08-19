defmodule MorphyDb.Position do
  defstruct [
    :fen,
    :pieces,
    :side_to_move,
    :en_passant,
    :castling_ability,
    :half_move_counter,
    :full_move_counter
  ]

  alias MorphyDb.FenParser

  def parse(fen) do
    {:ok, _, _, position, _, _} = FenParser.fen(fen)

    position
  end
end
