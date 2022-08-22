defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_component
  alias MorphyDb.Square

  prop click, :event, required: true
  prop square_index, :integer, required: true

  prop is_selected, :boolean, required: true
  prop is_highlighted, :boolean, required: true
  prop is_ctrl_highlighted, :boolean, required: true
  prop is_alt_highlighted, :boolean, required: true

  slot default, required: false

  defp is_light(square_index) do
    Square.is_light(square_index)
  end

  defp is_dark(square_index) do
    Square.is_dark(square_index)
  end
end
