defmodule MorphyDb.Square do
  alias MorphyDb.Bitboard

  alias __MODULE__

  @enforce_keys [:index, :rank, :file]
  defstruct [:index, :rank, :file]

  def new(square) do
    file = rem(square, 8)
    rank = div(square, 8)

    new(file, rank)
  end

  def new(file, rank), do: %Square{file: file, rank: rank, index: 8 * rank + file}

  def to_bitboard(%Square{index: index}), do: Bitboard.empty() |> Bitboard.set_bit(index)

  @doc ~S"""
  Returns true if the square is a light square

  ## Examples

      iex> 0 |> MorphyDb.Square.new() |> MorphyDb.Square.is_light?()
      false

      iex> 1 |> MorphyDb.Square.new() |> MorphyDb.Square.is_light?()
      true

      iex> 62 |> MorphyDb.Square.new() |> MorphyDb.Square.is_light?()
      true

      iex> 63 |> MorphyDb.Square.new() |> MorphyDb.Square.is_light?()
      false
  """
  def is_light?(%Square{file: file, rank: rank}), do: rem(file, 2) !== rem(rank, 2)

  @doc ~S"""
  Returns true if the square is a dark square

  ## Examples

      iex> 0 |> MorphyDb.Square.new() |> MorphyDb.Square.is_dark?()
      true

      iex> 1 |> MorphyDb.Square.new() |> MorphyDb.Square.is_dark?()
      false

      iex> 62 |> MorphyDb.Square.new() |> MorphyDb.Square.is_dark?()
      false

      iex> 63 |> MorphyDb.Square.new() |> MorphyDb.Square.is_dark?()
      true
  """
  def is_dark?(%Square{} = square), do: not is_light?(square)

  @doc ~S"""
  Toggles the bit located at square

  ## Examples

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.new(1)

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(8))
      MorphyDb.Bitboard.new(Integer.pow(2, 8))

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(0)) |> MorphyDb.Square.toggle(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.empty()

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(63)) |> MorphyDb.Square.toggle(MorphyDb.Square.new(63))
      MorphyDb.Bitboard.empty()
  """
  def toggle(%Bitboard{} = bitboard, %Square{index: index}), do: Bitboard.toggle(bitboard, index)

  @doc ~S"""
  Deselects the bit located at square

  ## Examples

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.deselect(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.empty()

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.deselect(MorphyDb.Square.new(0)) |> MorphyDb.Square.deselect(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.empty()

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(8)) |> MorphyDb.Square.deselect(MorphyDb.Square.new(8))
      MorphyDb.Bitboard.empty()
  """
  def deselect(%Bitboard{} = bitboard, %Square{index: index}), do: Bitboard.unset(bitboard, index)

  @doc ~s"""
  Returns true if the square is set in the bitboard

  ## Examples

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.is_set?(MorphyDb.Square.new(0))
      false

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(8)) |> MorphyDb.Square.is_set?(MorphyDb.Square.new(8))
      true

  """
  def is_set?(%Bitboard{} = bitboard, %Square{index: index}), do: Bitboard.is_set?(bitboard, index)
end
