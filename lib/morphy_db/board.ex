defmodule MorphyDb.Board do
  @type t() :: %__MODULE__{
    squares: [MorphyDb.Square.t()],
    position: MorphyDb.Position.t(),
    side: MorphyDb.Side.t()
  }

  @enforce_keys [:squares, :position, :side]
  defstruct [:squares, :position, :side]

  alias MorphyDb.Position
  alias MorphyDb.Square
  alias MorphyDb.File
  alias __MODULE__

  @spec new(MorphyDb.Position.t(), MorphyDb.Side.t()) :: MorphyDb.Board.t()
  def new(%Position{} = position, :w) do
    squares =
      for(rank <- 7..0, file <- 0..7, do: Square.new(File.to_file(file), rank))

    %Board{squares: squares, position: position, side: :w}
  end

  def new(%Position{} = position, :b) do
    squares =
      for(rank <- 0..7, file <- 7..0, do: Square.new(File.to_file(file), rank))

    %Board{squares: squares, position: position, side: :b}
  end

  @spec flip(MorphyDb.Board.t()) :: MorphyDb.Board.t()
  def flip(%Board{position: position, side: :w}), do: new(position, :b)
  def flip(%Board{position: position, side: :b}), do: new(position, :w)
end
