defmodule MorphyDBWeb.Components.TileComponent do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    rank = assigns.rank
    file = assigns.file

    color = if rem(file, 2) == rem(rank, 2), do: "light", else: "dark"

    {:ok,
     socket
     |> assign(assigns)
     |> assign(color: color)
    }
  end
end
