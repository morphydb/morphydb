defmodule MorphyDbWeb.ExampleLive do
  use Surface.LiveView

  alias MorphyDbWeb.Components.ExampleComponent

  def render(assigns) do
    ~F"""
    <ExampleComponent>
      Hi there!
    </ExampleComponent>
    """
  end
end
