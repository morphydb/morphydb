defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view

  alias MorphyDbWeb.Components.{BoardComponent, MoveTable}

  def mount(_params, _session, socket) do
    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    {:ok, assign(socket, :fen, "r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10")}
  end

  def handle_event("load_fen", %{"fen" => fen}, socket) do
    {:noreply, assign(socket, :fen, fen)}
  end
end
