defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view
  import MorphyDbWeb.Gettext

  alias MorphyDbWeb.Components.{BoardComponent, MoveTable}
  alias MorphyDb.Position
  alias MorphyDb.Board

  def mount(_params, _session, socket) do
    {:ok,
     socket |> setup("rnbqkbnr/ppppppp1/8/7p/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"),
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
