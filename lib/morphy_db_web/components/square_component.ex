defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_live_component
  alias MorphyDb.Square
  alias MorphyDbWeb.Components.PieceComponent

  prop click, :event, required: false
  prop square, :map, required: true

  prop is_selected, :boolean, required: true
  prop is_ctrl_highlighted, :boolean, required: true
  prop is_alt_highlighted, :boolean, required: true

  defp is_light(square_index), do: Square.is_light(square_index)

  defp is_dark(square_index), do: Square.is_dark(square_index)
end
