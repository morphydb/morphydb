defmodule Chess.Games.Commands.Handlers.LoadFenHandler do
  alias Chess.Games.Commands.CommandHandler
  alias Chess.Games.Commands.LoadFen
  alias Chess.Games.Events.FenLoaded
  alias Chess.Games.Game

  defimpl CommandHandler, for: LoadFen do
    def handle_command(%LoadFen{fen: fen}, %Game{}), do: [FenLoaded.new(fen)]
  end
end
