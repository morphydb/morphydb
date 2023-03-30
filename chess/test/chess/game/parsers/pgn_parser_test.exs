defmodule Game.Parsers.PgnParserTest do
  alias Game.Parsers.PgnParser

  use ExUnit.Case
  doctest PgnParser

  describe "Parsing tags" do
    test "Event" do
      pgn = ~s([Event "Some event"][Site "Some site"] 1. d4 Nf6 *)

      r = PgnParser.parse(pgn)
      IO.inspect(r)
      # %{tags: [:event, "Second event"]} = PgnParser.parse(~s([Event "Second event"]))
    end
  end
end
