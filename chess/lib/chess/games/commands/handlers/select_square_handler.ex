defmodule Chess.Games.Commands.Handlers.SelectSquareHandler do
  alias Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.SelectSquare
  alias Chess.Games.Commands.ClearMarks
  alias Chess.Games.Events.SquareSelected
  alias Chess.Games.Events.SquareHighlighted
  alias Chess.Games.Game

  defimpl CommandHandler, for: SelectSquare do
    def handle_command(%SelectSquare{}, %Game{highlighted_squares: highlighted_squares} = game)
        when map_size(highlighted_squares) > 0,
        do: CommandHandler.handle_command(%ClearMarks{}, game)

    def handle_command(
          %SelectSquare{
            square_index: square_index
          },
          %Game{selected_square: selected_square, highlighted_squares: highlighted_squares}
        )
        when selected_square != square_index,
        do: [
          SquareSelected.new(square_index)
          | Enum.map(highlighted_squares, fn {square, _} ->
              SquareHighlighted.new(square, :none)
            end)
        ]

    def handle_command(
          %SelectSquare{square_index: square_index},
          %Game{selected_square: selected_square} = game
        )
        when selected_square == square_index,
        do: CommandHandler.handle_command(%ClearMarks{}, game)
  end
end
