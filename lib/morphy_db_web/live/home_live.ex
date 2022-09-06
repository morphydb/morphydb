defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view
  import MorphyDbWeb.Gettext

  alias MorphyDbWeb.Components.{BoardComponent, MoveTable}
  alias MorphyDb.Position
  alias MorphyDb.Board

  def mount(_params, _session, socket) do
    {:ok,
     socket |> setup("rnbqkbnr/pp4pp/P4p1P/3p4/2pPp3/8/1PP1PPP1/RNBQKBNR b KQkq d3 0 8"),
     temporary_assigns: [error: []]}
  end

  def handle_event("load_fen", %{"fen" => fen}, socket) do
    {:noreply, socket |> setup(fen)}
  end

  def handle_event("clear_errors", _params, socket) do
    {:noreply, socket}
  end

  defp setup(socket, fen) do
    case Position.parse(fen) do
      {:ok, position} ->
        socket
        |> assign(:fen, fen)
        |> assign(:board, Board.new(position, :w))

      {:error, :invalid_fen} ->
        socket
        |> put_flash(:error, dgettext("errors", "%{fen} is not a valid FEN", fen: fen))
    end
  end
end
