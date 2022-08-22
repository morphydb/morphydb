defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view

  alias MorphyDbWeb.Components.{BoardComponent, MoveTable}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :fen, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")}
  end

  def handle_event("update_fen", %{"fen" => fen}, socket) do
    {:noreply, assign(socket, :fen, fen)}
  end
end
