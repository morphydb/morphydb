defmodule Game.Move do
  alias __MODULE__

  alias Game.Square

  @opaque t() :: %Move{
            from: Square.t(),
            to: Square.t()
          }

  @enforce_keys [:from, :to]

  defstruct [:from, :to]
end
