defmodule MorphyDb.Square do
  alias MorphyDb.Bitboard

  alias __MODULE__

  @enforce_keys [:index, :rank, :file]
  defstruct [:index, :rank, :file]

  def light_squares, do: Bitboard.new(0x55AA55AA55AA55AA)
  def dark_squares, do: Bitboard.new(0xAA55AA55AA55AA55)

  def new(square_index) do
    file = rem(square_index, 8)
    rank = div(square_index, 8)

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
  def is_light?(%Square{index: index}), do: Bitboard.is_set?(light_squares(), index)

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
  def is_dark?(%Square{index: index}), do: Bitboard.is_set?(dark_squares(), index)

  @doc ~S"""
  Toggles the bit located at square_index

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
  Deselects the bit located at square_index

  ## Examples

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.deselect(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.empty()

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.deselect(MorphyDb.Square.new(0)) |> MorphyDb.Square.deselect(MorphyDb.Square.new(0))
      MorphyDb.Bitboard.empty()

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(8)) |> MorphyDb.Square.deselect(MorphyDb.Square.new(8))
      MorphyDb.Bitboard.empty()
  """
  def deselect(%Bitboard{} = bitboard, %Square{index: index}), do: Bitboard.unset(bitboard, index)

  def is_set?(%Bitboard{} = bitboard, %Square{index: index}), do: Bitboard.is_set?(bitboard, index)
end
