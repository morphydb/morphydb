defmodule Chess.Games.Commands.SelectSquare do
  @enforce_keys [:square_index]
  defstruct [:square_index]

  @type t() :: %__MODULE__{
          square_index: integer()
        }
end
