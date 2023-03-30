defmodule Chess.Games.Commands.DrawArrow do
  @enforce_keys [:from, :to]
  defstruct [:from, :to]

  @type t() :: %__MODULE__{
    from: integer(),
    to: integer()
  }
end
