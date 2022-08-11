defmodule MorphyDbWeb.Components.Hello do
  use Surface.Component

  @doc "Someone to say hello to"
  prop name, :string, required: true

  def render(assigns) do
    ~F"""
    Hello, {@name}!
    """
  end
end
