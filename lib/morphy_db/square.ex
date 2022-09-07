defmodule MorphyDb.Square do
  alias MorphyDb.Bitboard
  alias MorphyDb.Rank
  alias MorphyDb.File

  alias __MODULE__

  @type index() :: 0..63

  @type t() :: %__MODULE__{
    rank: Rank.t(),
    file: File.t()
  }

  @enforce_keys [:rank, :file]
  defstruct [:rank, :file]

  @spec new(index()) :: t()
  def new(square_index) do
    file = rem(square_index, 8) |> File.to_file()
    rank = div(square_index, 8)

    new(file, rank)
  end

  @spec new(File.t(), Rank.t()) :: MorphyDb.Square.t()
  def new(file, rank), do: %Square{file: file, rank: rank}

  @spec to_bitboard(t()) :: Bitboard.t()
  def to_bitboard(square), do: Bitboard.empty() |> Bitboard.set_bit(to_index(square))

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
  @spec is_light?(MorphyDb.Square.t()) :: boolean
  def is_light?(%Square{file: file, rank: rank}), do: rem(File.to_integer(file), 2) !== rem(rank, 2)

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
  @spec is_dark?(MorphyDb.Square.t()) :: boolean
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
  @spec toggle(MorphyDb.Bitboard.t(), MorphyDb.Square.t()) :: MorphyDb.Bitboard.t()
  def toggle(%Bitboard{} = bitboard, %Square{} = square), do: Bitboard.toggle(bitboard, to_index(square))

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
  @spec deselect(MorphyDb.Bitboard.t(), MorphyDb.Square.t()) :: MorphyDb.Bitboard.t()
  def deselect(%Bitboard{} = bitboard, %Square{} = square), do: Bitboard.unset(bitboard, to_index(square))

  @doc ~s"""
  Returns true if the square is set in the bitboard

  ## Examples

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.is_set?(MorphyDb.Square.new(0))
      false

      iex> MorphyDb.Bitboard.empty() |> MorphyDb.Square.toggle(MorphyDb.Square.new(8)) |> MorphyDb.Square.is_set?(MorphyDb.Square.new(8))
      true

  """
  @spec is_set?(MorphyDb.Bitboard.t(), MorphyDb.Square.t()) :: boolean
  def is_set?(%Bitboard{} = bitboard, %Square{} = square), do: Bitboard.is_set?(bitboard, to_index(square))

  @spec to_index(MorphyDb.Square.t()) :: MorphyDb.Square.index()
  def to_index(%Square{file: file, rank: rank}), do: rank * 8 + File.to_integer(file)
end
