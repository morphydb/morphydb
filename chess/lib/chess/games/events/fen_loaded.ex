defmodule Chess.Games.Events.FenLoaded do
  @enforce_keys [:fen]
  defstruct [:fen]

  @opaque t() :: %__MODULE__{
            fen: String.t()
          }

  def new(fen) when is_bitstring(fen),
    do: %__MODULE__{
      fen: fen
    }
end
