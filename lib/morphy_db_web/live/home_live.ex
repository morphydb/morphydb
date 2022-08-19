defmodule MorphyDbWeb.HomeLive do
  use MorphyDbWeb, :surface_live_view

  alias MorphyDbWeb.Components.BoardComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Submit}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :fen, "4k3/8/8/8/8/8/4P3/4K3 w - - 5 39")}
  end

  def handle_event("update_fen", %{"position" => %{"fen" => fen}}, socket) do
    {:noreply, assign(socket, :fen, fen)}
  end
end
