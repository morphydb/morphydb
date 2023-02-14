defmodule Chess.Games.Commands.HighlightSquare do
  @enforce_keys [:square_index, :mode]
  defstruct [:square_index, :mode]

  @type t() :: %__MODULE__{
    square_index: integer(),
    mode: :normal | :alt | :ctrl
  }
end
