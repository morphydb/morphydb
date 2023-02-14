defmodule Chess.Games.Commands.Handlers.DrawArrowHandler do
  alias Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.DrawArrow
  alias Chess.Games.Events.ArrowRemoved
  alias Chess.Games.Events.ArrowAdded
  alias Chess.Games.Game

  defimpl CommandHandler, for: DrawArrow do
    def handle_command(
          %DrawArrow{} = arrow,
          %Game{arrows: arrows}
        ) do
      if(Enum.member?(arrows, Map.from_struct(arrow))) do
        [ArrowRemoved.new(arrow.from, arrow.to)]
      else
        [ArrowAdded.new(arrow.from, arrow.to)]
      end
    end
  end
end
