defmodule MorphyDb.BitboardTest do
  use ExUnit.Case, async: true

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  describe "is_set" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Square index #{square_index} in an empty board is not set" do
        actual =
          Bitboard.empty()
          |> Bitboard.is_set?(unquote(square_index))

        assert actual === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "Square index #{square_index} in a full board is set" do
        actual =
          Bitboard.universal()
          |> Bitboard.is_set?(unquote(square_index))

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
          |> Bitboard.is_set?(unquote(square_index))

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
          |> Bitboard.is_set?(unquote(square_index))

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
          |> Bitboard.is_set?(unquote(square_index))

        assert actual === true
      end
    end)
  end

  describe "intersect" do
    test "The intersection of universal and light squares are the light squares" do
      actual =
        Bitboard.universal()
        |> Bitboard.intersect(MorphyDb.Square.light_squares())

      assert actual === MorphyDb.Square.light_squares()
    end

    test "The intersection of universal and dark squares are the dark squares" do
      actual =
        Bitboard.universal()
        |> Bitboard.intersect(MorphyDb.Square.dark_squares())

      assert actual === MorphyDb.Square.dark_squares()
    end

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "The intersection of #{square_index} with an empty bitboard is empty" do
        actual =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square_index))
          |> Bitboard.intersect(Bitboard.empty())

        assert actual === Bitboard.empty()
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "The intersection of #{square_index} with an universal bitboard is #{square_index}" do
        square =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square_index))

        actual = Bitboard.intersect(Bitboard.universal(), square)

        assert actual === square
      end
    end)
  end

  describe "intersects?" do
    test "Universal and light squares intersects" do
      assert Bitboard.intersects?(Bitboard.universal(), Square.light_squares())
    end

    test "Universal and dark squares intersects" do
      assert Bitboard.intersects?(Bitboard.universal(), Square.dark_squares())
    end

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "#{square_index} does not intersect with an empty bitboard" do
        square =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square_index))

        assert Bitboard.intersects?(Bitboard.empty(), square) === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square_index ->
      test "#{square_index} intersects with an universal bitboard" do
        square =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square_index))

        assert Bitboard.intersects?(Bitboard.universal(), square)
      end
    end)
  end
end
