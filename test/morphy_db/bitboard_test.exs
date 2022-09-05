defmodule MorphyDb.BitboardTest do
  use ExUnit.Case, async: true

  alias MorphyDb.Bitboard
  alias MorphyDb.Square

  describe "is_set" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Square index #{square} in an empty board is not set" do
        actual =
          Bitboard.empty()
          |> Bitboard.is_set?(unquote(square))

        assert actual === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Square index #{square} in a full board is set" do
        actual =
          Bitboard.universal()
          |> Bitboard.is_set?(unquote(square))

        assert actual === true
      end
    end)
  end

  describe "unset" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Unsetting #{square} in a full board is not set" do
        actual =
          Bitboard.universal()
          |> Bitboard.unset(unquote(square))
          |> Bitboard.is_set?(unquote(square))

        assert actual === false
      end
    end)
  end

  describe "get_bit" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Getting #{square} in a full board is 2^square" do
        actual =
          Bitboard.universal()
          |> Bitboard.get_bit(unquote(square))

        assert actual === Integer.pow(2, unquote(square))
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Getting #{square} in an empty board is 0" do
        actual =
          Bitboard.empty()
          |> Bitboard.get_bit(unquote(square))

        assert actual === 0
      end
    end)
  end

  describe "set_bit" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Set #{square} in a full board doesn't change the board" do
        actual =
          Bitboard.universal()
          |> Bitboard.set_bit(unquote(square))

        assert actual === Bitboard.universal()
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Set #{square} in an empty board results in 2^square" do
        actual =
          Bitboard.empty()
          |> Bitboard.set_bit(unquote(square))

        assert actual.value === Integer.pow(2, unquote(square))
      end
    end)
  end

  describe "toggle" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Toggling #{square} in a full board unsets that index" do
        actual =
          Bitboard.universal()
          |> Bitboard.toggle(unquote(square))
          |> Bitboard.is_set?(unquote(square))

        assert actual === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "Toggling #{square} in an empty board sets that index" do
        actual =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square))
          |> Bitboard.is_set?(unquote(square))

        assert actual === true
      end
    end)
  end

  describe "intersect" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "The intersection of #{square} with an empty bitboard is empty" do
        actual =
          Bitboard.empty()
          |> Bitboard.toggle(unquote(square))
          |> Bitboard.intersect(Bitboard.empty())

        assert actual === Bitboard.empty()
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "The intersection of #{square} with an universal bitboard is #{square}" do
        square =
          unquote(square)
          |> Square.new()
          |> Square.to_bitboard()

        actual = Bitboard.intersect(Bitboard.universal(), square)

        assert actual === square
      end
    end)
  end

  describe "intersects?" do
    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "#{square} does not intersect with an empty bitboard" do
        square =
          unquote(square)
          |> Square.new()
          |> Square.to_bitboard()

        assert square |> Bitboard.intersects?(Bitboard.empty()) === false
      end
    end)

    0..63
    |> Enum.to_list()
    |> Enum.each(fn square ->
      test "#{square} intersects with an universal bitboard" do
        square =
          unquote(square)
          |> Square.new()
          |> Square.to_bitboard()

        assert square |> Bitboard.intersects?(Bitboard.universal())
      end
    end)
  end

  describe "union" do
    test "A bitboard union itself is itself" do
      bitboard = Bitboard.empty() |> Bitboard.set_bit(1)

      assert bitboard |> Bitboard.union(bitboard) === bitboard
    end

    test "Empty bitboard union itself is itself" do
      bitboard = Bitboard.empty()

      assert bitboard |> Bitboard.union(bitboard) === bitboard
    end

    test "Universal bitboard union itself is itself" do
      bitboard = Bitboard.universal()

      assert bitboard |> Bitboard.union(bitboard) === bitboard
    end

    test "Only the bits in both bitboards are set" do
      bitboard1 = Bitboard.empty() |> Bitboard.set_bit(0)
      bitboard2 = Bitboard.empty() |> Bitboard.set_bit(1)

      bitboard = Bitboard.union(bitboard1, bitboard2)

      assert Bitboard.is_set?(bitboard, 0)
      assert Bitboard.is_set?(bitboard, 1)

      2..63
      |> Enum.each(fn square -> assert not Bitboard.is_set?(bitboard, square) end)
    end
  end

  describe "complement" do
    test "Bitboard does not intersect its complement" do
      bitboard = Bitboard.empty() |> Bitboard.set_bit(1)
      complement = bitboard |> Bitboard.complement()

      assert Bitboard.intersects?(bitboard, complement) === false
    end

    test "Union of a bitboard and its complement is universal" do
      bitboard = Bitboard.empty() |> Bitboard.set_bit(1)
      complement = bitboard |> Bitboard.complement()
      total = bitboard |> Bitboard.union(complement)

      assert total === Bitboard.universal()
    end

    test "Complement of the complement is the original" do
      bitboard = Bitboard.empty() |> Bitboard.set_bit(1)
      complement = bitboard |> Bitboard.complement() |> Bitboard.complement()

      assert complement === bitboard
    end

    test "Complement of empty is universal" do
      bitboard = Bitboard.empty() |> Bitboard.complement()

      assert bitboard === Bitboard.universal()
    end

    test "Complement of universal is empty" do
      bitboard = Bitboard.universal() |> Bitboard.complement()

      assert bitboard === Bitboard.empty()
    end
  end
end
