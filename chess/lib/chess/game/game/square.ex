defmodule Game.Square do
  alias __MODULE__

  import Bitwise

  @opaque t() :: %Square{
            index: integer(),
            file: integer(),
            rank: integer()
          }

  @enforce_keys [:index, :rank, :file]

  defstruct [:index, :rank, :file]

  def new(%{file: file_index, rank: rank_index}) when file_index in 0..7 and rank_index in 0..7,
    do: new(file_index + 8 * rank_index)

  def new(square_index),
    do: %Square{index: square_index, file: band(square_index, 7), rank: bsr(square_index, 3)}

  def dark?(%Square{file: file, rank: rank}), do: rem(file, 2) === rem(rank, 2)
  def light?(%Square{} = square), do: not dark?(square)

  def to_square_index(%Square{file: file, rank: rank}), do: file + 8 * rank

  defimpl String.Chars, for: Square do
    def to_string(%Square{file: file, rank: rank}) do
      <<?a + file>> <> Integer.to_string(rank + 1)
    end
  end
end
