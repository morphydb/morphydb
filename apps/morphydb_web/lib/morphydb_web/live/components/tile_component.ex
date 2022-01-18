defmodule MorphyDBWeb.Components.TileComponent do
  use Surface.Component

  prop rank, :integer, required: true
  prop file, :integer, required: true
  prop highlight, :integer, required: true
  prop on_highlight, :event, required: true

  def render(assigns) do
    light = rem(assigns.file, 2) == rem(assigns.rank, 2)
    dark = not light

    ~F"""
    <div
        class={"flex", "pb-full", "w-full", "h-0", "tile", "tile-dark": dark, "tile-light": light}
        :on-click={@on_highlight} phx-value-rank={@rank} phx-value-file={@file}>
        <div class={"pb-full", "tile-highlight": @highlight == 0, "tile-highlight1": @highlight == 1, "tile-highlight2": @highlight == 2, "tile-highlight3": @highlight == 3}>
        </div>
    </div>
    """
  end
end
