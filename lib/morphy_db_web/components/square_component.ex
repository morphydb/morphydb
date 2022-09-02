defmodule MorphyDbWeb.Components.SquareComponent do
  use MorphyDbWeb, :surface_live_component
  alias MorphyDb.Square
  alias MorphyDbWeb.Components.PieceComponent

  prop click, :event, required: true

  prop square, :struct, required: true
  prop piece, :struct, required: true

  prop is_selected, :boolean, required: true
  prop is_selected_with_ctrl, :boolean, required: true
  prop is_selected_with_alt, :boolean, required: true
  prop is_move, :boolean, required: true
  prop is_attacked, :boolean, required: true

  defp is_light?(%Square{} = square), do: Square.is_light?(square)

  defp is_dark?(%Square{} = square), do: Square.is_dark?(square)
end
