defmodule MorphyDb.BitboardTest do
  use ExUnit.Case, async: true

  alias MorphyDb.Bitboard

  describe "is_set" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Square index #{square_index} in an empty board is not set" do
        actual =
          Bitboard.empty()
          |> Bitboard.is_set(unquote(square_index))

        assert actual === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Square index #{square_index} in a full board is set" do
        actual =
          Bitboard.universal()
          |> Bitboard.is_set(unquote(square_index))

        assert actual === true
      end
    end)
  end

  describe "unset" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Unsetting #{square_index} in a full board is not set" do
        actual =
          Bitboard.universal()
          |> Bitboard.unset(unquote(square_index))
          |> Bitboard.is_set(unquote(square_index))

        assert actual === false
      end
    end)
  end

  describe "get_bit" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Getting #{square_index} in a full board is 2^square_index" do
        actual =
          Bitboard.universal()
          |> Bitboard.get_bit(unquote(square_index))

        assert actual === Integer.pow(2, unquote(square_index))
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Getting #{square_index} in an empty board is 0" do
        actual =
          Bitboard.empty()
          |> Bitboard.get_bit(unquote(square_index))

        assert actual === 0
      end
    end)
  end

  describe "set_bit" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Set #{square_index} in a full board doesn't change the board" do
        actual =
          Bitboard.universal()
          |> Bitboard.set_bit(unquote(square_index))

        assert actual === Bitboard.universal()
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Set #{square_index} in an empty board results in 2^square_index" do
        actual =
          Bitboard.empty()
          |> Bitboard.set_bit(unquote(square_index))

        assert actual === Integer.pow(2, unquote(square_index))
      end
    end)
  end

  describe "toggle" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Toggling #{square_index} in a full board unsets that index" do
        actual =
          Bitboard.universal()
          |> Bitboard.toggle(unquote(square_index))
          |> Bitboard.is_set(unquote(square_index))

        assert actual === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Toggling #{square_index} in an empty board sets that index" do
        actual =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square_index))
          |> Bitboard.is_set(unquote(square_index))

        assert actual === true
      end
    end)
  end
end
