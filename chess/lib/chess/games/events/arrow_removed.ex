defmodule Chess.Games.Events.ArrowRemoved do
  @enforce_keys [:from, :to]
  defstruct [:from, :to]

  @opaque t() :: %__MODULE__{
            from: integer(),
            to: integer()
          }

  def new(from, to) when is_integer(from) and is_integer(to),
    do: %__MODULE__{
      from: from,
      to: to
    }
end
