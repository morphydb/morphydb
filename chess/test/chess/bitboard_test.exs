defmodule Chess.BitboardTest do
  use ExUnit.Case, async: true

  alias Chess.Bitboard

  describe "set" do
    0..63
    |> Enum.each(fn bit ->
      test "Set #{bit} in an empty bitboard" do
        assert Bitboard.empty()
               |> Bitboard.set(unquote(bit))
               |> Bitboard.set?(unquote(bit))
      end
    end)
  end
end
