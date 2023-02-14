defmodule Chess.Games.Events.SquareHighlighted do
  @enforce_keys [:square_index, :mode]
  defstruct [:square_index, :mode]

  @opaque t() :: %__MODULE__{
          square_index: integer(),
          mode: :none | :normal | :alt | :ctrl
        }

  def new(square_index, mode) when is_integer(square_index) and mode in [:none, :normal, :alt, :ctrl],
        do: %__MODULE__{
          square_index: square_index,
          mode: mode
        }
end
