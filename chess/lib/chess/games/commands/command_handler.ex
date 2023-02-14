defprotocol Chess.Games.Commands.CommandHandler do
  alias Chess.Games.Game

  @spec handle_command(t(), Game.t()) :: list()
  def handle_command(command, game)
end
