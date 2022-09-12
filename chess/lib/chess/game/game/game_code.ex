defmodule Game.GameCode do
  alias __MODULE__

  @opaque t() :: %GameCode{
            game_id: String.t()
          }

  @enforce_keys [:game_id]

  defstruct [:game_id]

  def new(),
    do:
      Nanoid.generate()
      |> create()

  def create(game_id), do: %GameCode{game_id: game_id}

  defimpl String.Chars, for: GameCode do
    def to_string(%GameCode{game_id: game_id}) do
      game_id
    end
  end
end
