defmodule MorphyDBWeb.Components.TileComponent do
  use Surface.LiveComponent

  prop rank, :integer
  prop file, :integer

  data highlighted, :boolean, default: false

  def render(assigns) do
    light = rem(assigns.file, 2) == rem(assigns.rank, 2)
    dark = not light

    ~F"""
    <div
        class={"flex", "pb-full", "w-full", "h-0", "tile", "tile-dark": dark, "tile-light": light}
        :on-click="toggle_highlight">
        <div class={"pb-full", "tile-highlight": @highlighted}>
        </div>
    </div>
    """
  end

  def handle_event("toggle_highlight", _params, socket) do
    {:noreply, update(socket, :highlighted, &(not &1))}
  end
end
