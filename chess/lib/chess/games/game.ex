defmodule Chess.Games.Game do
  alias __MODULE__

  alias Chess.Games.Events.ArrowRemoved
  alias Chess.Games.Events.ArrowAdded
  alias Chess.Games.Events.{FenLoaded, SquareSelected, SquareDeselected, SquareHighlighted}

  require Logger

  defstruct [:fen, :selected_square, :highlighted_squares, :arrows]

  @type t() :: %__MODULE__{
          fen: String.t(),
          selected_square: integer(),
          highlighted_squares: %{required(integer()) => :normal | :alt | :ctrl},
          arrows: list()
        }

  def build_state(events),
    do:
      List.foldl(events, %Game{highlighted_squares: %{}, arrows: []}, fn event, game ->
        apply_event(game, event)
      end)

  defp apply_event(%Game{} = game, %ArrowAdded{} = event),
    do: %{game | arrows: [Map.from_struct(event) | game.arrows]}

  defp apply_event(%Game{} = game, %ArrowRemoved{} = event),
    do: %{game | arrows: Enum.reject(game.arrows, fn arrow -> arrow == Map.from_struct(event) end)}

  defp apply_event(%Game{} = game, %FenLoaded{} = event), do: %{game | fen: event.fen}

  defp apply_event(%Game{} = game, %SquareDeselected{}),
    do: %{game | selected_square: nil}

  defp apply_event(%Game{} = game, %SquareHighlighted{square_index: square_index, mode: :none}),
    do: %{game | highlighted_squares: Map.delete(game.highlighted_squares, square_index)}

  defp apply_event(%Game{} = game, %SquareHighlighted{square_index: square_index, mode: mode}),
    do: %{game | highlighted_squares: Map.put(game.highlighted_squares, square_index, mode)}

  defp apply_event(%Game{} = game, %SquareSelected{square_index: square_index}),
    do: %{game | selected_square: square_index}
end
