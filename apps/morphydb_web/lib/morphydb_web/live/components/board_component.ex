defmodule MorphyDBWeb.Components.BoardComponent do
  use Surface.LiveComponent

  alias MorphyDBWeb.Components.TileComponent

  def render(assigns) do
    ~F"""
    <div class="max-w-screen-sm md:max-w-screen-md p-4">
      <div class="grid grid-cols-8 gap-0">
          {#for rank <- 1..8}
              {#for file <- 1..8}
                  <TileComponent id={rank * 8 + file} rank={rank} file={file} />
              {/for}
          {/for}
      </div>
    </div>
    """
  end
end
