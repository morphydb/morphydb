defmodule Chess.Games.Events.SquareSelected do
  @enforce_keys [:square_index]
  defstruct [:square_index]

  @opaque t() :: %__MODULE__{
          square_index: integer()
        }

  def new(square_index) when is_integer(square_index),
    do: %__MODULE__{
      square_index: square_index
    }
end
