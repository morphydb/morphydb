defmodule Chess.Games.Commands.Handlers.ClearMarksHandler do
  alias Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.ClearMarks
  alias Chess.Games.Events.ArrowRemoved
  alias Chess.Games.Game

  defimpl CommandHandler, for: ClearMarks do
    alias Chess.Games.Events.SquareHighlighted
    alias Chess.Games.Events.SquareDeselected

    def handle_command(
          %ClearMarks{},
          %Game{
            selected_square: selected_square,
            highlighted_squares: highlighted_squares,
            arrows: arrows
          }
        ) do
      s = clear_selected_square(selected_square)
      a = Enum.map(arrows, fn arrow -> ArrowRemoved.new(arrow.from, arrow.to) end)

      h =
        highlighted_squares
        |> Map.to_list()
        |> Enum.map(fn {square_index, _mode} -> SquareHighlighted.new(square_index, :none) end)

      IO.puts("Result: #{inspect(s)} #{inspect(a)} #{inspect(a)}")

      s ++ a ++ h
    end

    defp clear_selected_square(nil), do: []

    defp clear_selected_square(selected_square),
      do: [SquareDeselected.new(selected_square)]
  end
end
