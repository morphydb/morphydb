defmodule Chess.Games.Commands.Handlers.HighlightSquareHandler do
  alias Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.HighlightSquare
  alias Chess.Games.Events.SquareHighlighted
  alias Chess.Games.Game

  defimpl CommandHandler, for: HighlightSquare do
    def handle_command(
      %HighlightSquare{
        square_index: square_index,
        mode: mode
      },
      %Game{highlighted_squares: highlighted_squares}) do
      case Map.get(highlighted_squares, square_index) do
        ^mode -> [SquareHighlighted.new(square_index, :none)]
        _ -> [SquareHighlighted.new(square_index, mode)]
      end
    end
  end
end
