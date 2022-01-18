defmodule MorphyDBWeb.Components.BoardComponent do
  use Surface.LiveComponent

  alias MorphyDBWeb.Components.TileComponent

  data highlighted, :map, default: %{}

  def render(assigns) do
    ~F"""
    <div class="max-w-screen-sm md:max-w-screen-md p-4">
      <div class="grid grid-cols-8 gap-0">
          {#for rank <- 1..8}
              {#for file <- 1..8}
                  <TileComponent rank={rank} file={file} highlight={Map.get(@highlighted, {file, rank})} on_highlight="toggle_highlight" />
              {/for}
          {/for}
      </div>
    </div>
    """
  end

  def handle_event("toggle_highlight", %{"ctrlKey" => false, "altKey" => false, "rank" => rank, "file" => file}, socket) do
    key = {String.to_integer(file), String.to_integer(rank)}

    {:noreply,
     socket
     |> update(
       :highlighted,
       fn h ->
         if Map.has_key?(h, key) or Enum.any?(Map.values(h), fn v -> v > 0 end) do
           %{}
         else
           Map.put(%{}, key, 0)
         end
       end
     )}
  end

  def handle_event(
        "toggle_highlight",
        %{"ctrlKey" => true, "altKey" => false, "rank" => rank, "file" => file},
        socket
      ) do

    handle_toggle_highlight file, rank, 1, socket
  end

  def handle_event(
        "toggle_highlight",
        %{"ctrlKey" => false, "altKey" => true, "rank" => rank, "file" => file},
        socket
      ) do

    handle_toggle_highlight file, rank, 2, socket
  end

  def handle_event(
        "toggle_highlight",
        %{"ctrlKey" => true, "altKey" => true, "rank" => rank, "file" => file},
        socket
      ) do

    handle_toggle_highlight file, rank, 3, socket
  end

  defp handle_toggle_highlight(file, rank, value, socket) do
    key = {String.to_integer(file), String.to_integer(rank)}

    {:noreply,
     socket
     |> update(
       :highlighted,
       fn h -> delete_or_add(h, key, value) end
     )}
  end

  defp delete_or_add(map, key, value) do
    if Map.has_key?(map, key) and Map.get(map, key) == value do
      Map.delete(map, key)
    else
      Map.put(map, key, value)
    end
  end
end
