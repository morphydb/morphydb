defmodule MorphyDb.Board do
  @enforce_keys [:squares, :position, :side]
  defstruct [:squares, :position, :side]

  alias MorphyDb.Position
  alias MorphyDb.Square
  alias __MODULE__

  def new(%Position{} = position, :w) do
    squares =
      for(rank <- 7..0, file <- 0..7, do: Square.new(file, rank))

    %Board{squares: squares, position: position, side: :w}
  end

  def new(%Position{} = position, :b) do
    squares =
      for(rank <- 0..7, file <- 7..0, do: Square.new(file, rank))

    %Board{squares: squares, position: position, side: :b}
  end

  def flip(%Board{position: position, side: :w}), do: new(position, :b)
  def flip(%Board{position: position, side: :b}), do: new(position, :w)
end
