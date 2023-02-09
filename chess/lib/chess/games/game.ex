defmodule Chess.Games.Game do
  alias __MODULE__

  alias Chess.Games.Events.FenLoaded
  alias Chess.Games.Commands.LoadFen

  defstruct [:fen]

  def handle_message(history, command),
    do:
      history
      |> build_state()
      |> handle(command)

  defp build_state(events),
    do: List.foldl(events, %Game{}, fn event, state -> apply_event(state, event) end)

  defp apply_event(%Game{} = state, %FenLoaded{} = event), do: %{state | fen: event.fen}

  defp handle(%Game{} = _state, %LoadFen{fen: fen}) do
    [
      %FenLoaded{fen: fen}
    ]
  end
end
