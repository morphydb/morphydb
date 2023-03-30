defmodule Chess.Games.Commands.LoadFen do
  @enforce_keys [:fen]
  defstruct [:fen]

  @type t() :: %__MODULE__{
          fen: String.t()
        }
end
