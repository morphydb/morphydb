defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_live_component
  alias MorphyDb.Square
  alias MorphyDbWeb.Components.PieceComponent

  prop click, :event, required: true

  prop square, :map, required: true

  prop is_selected, :boolean, required: true
  prop is_selected_with_ctrl, :boolean, required: true
  prop is_selected_with_alt, :boolean, required: true
  prop is_attacked, :boolean, required: true

  defp is_light(square_index), do: Square.is_light(square_index)

  defp is_dark(square_index), do: Square.is_dark(square_index)
end
