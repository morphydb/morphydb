defmodule MorphyDb.Square.Guards do
  defguard is_square(square_index) when square_index in 0..63
end

defmodule MorphyDb.Square do
  alias MorphyDb.Bitboard

  import MorphyDb.Square.Guards

  @spec to_square_index(number, number) :: number
  def to_square_index(file_index, rank_index), do: 8 * rank_index + file_index

  @doc ~S"""
  Returns true if the square is a light square

  ## Examples

      iex> MorphyDb.Square.is_light(0)
      false

      iex> MorphyDb.Square.is_light(1)
      true

      iex> MorphyDb.Square.is_light(62)
      true

      iex> MorphyDb.Square.is_light(63)
      false
  """
  def is_light(square_index) when is_square(square_index) do
    Bitboard.is_set(Bitboard.light_squares(), square_index)
  end

  @doc ~S"""
  Returns true if the square is a dark square

  ## Examples

      iex> MorphyDb.Square.is_dark(0)
      true

      iex> MorphyDb.Square.is_dark(1)
      false

      iex> MorphyDb.Square.is_dark(62)
      false

      iex> MorphyDb.Square.is_dark(63)
      true
  """
  def is_dark(square_index) when is_square(square_index) do
    Bitboard.is_set(Bitboard.dark_squares(), square_index)
  end

  @doc ~S"""
  Toggles the bit located at square_index

  ## Examples

      iex> 0 |> MorphyDb.Square.toggle(0)
      1

      iex> 0 |> MorphyDb.Square.toggle(8)
      Integer.pow(2, 8)

      iex> 0 |> MorphyDb.Square.toggle(0) |> MorphyDb.Square.toggle(0)
      0

      iex> 0 |> MorphyDb.Square.toggle(63) |> MorphyDb.Square.toggle(63)
      0
  """
  def toggle(bitboard, square_index) when is_square(square_index) do
    Bitboard.toggle(bitboard, square_index)
  end

  @doc ~S"""
  Deselects the bit located at square_index

  ## Examples

      iex> 0 |> MorphyDb.Square.deselect(0)
      0

      iex> 0 |> MorphyDb.Square.deselect(0) |> MorphyDb.Square.deselect(0)
      0

      iex> 0 |> MorphyDb.Square.toggle(8) |> MorphyDb.Square.deselect(8)
      0
  """
  def deselect(bitboard, square_index) when is_square(square_index) do
    Bitboard.unset(bitboard, square_index)
  end
end
