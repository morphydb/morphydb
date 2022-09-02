defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view
  import MorphyDbWeb.Gettext


  alias MorphyDbWeb.Components.{BoardComponent, MoveTable}
  alias MorphyDb.Position

  def mount(_params, _session, socket) do
    {:ok,
     socket |> setup("r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10"),
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
        |> assign(:position, position)

      {:error, :invalid_fen} ->
        socket
        |> put_flash(:error, dgettext("errors", "%{fen} is not a valid FEN", fen: fen))
    end
  end
end
