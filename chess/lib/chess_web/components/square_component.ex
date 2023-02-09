defmodule ChessWeb.Components.SquareComponent do
  alias Phoenix.LiveView.JS
  alias Chess.Games.Square

  use ChessWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      phx-click={
        JS.push("select",
          value: %{square_index: Square.to_square_index(@square)},
          target: "#board"
        )
      }
      id={@id}
      data-square_index={Square.to_square_index(@square)}
      class={["relative", Square.dark?(@square) && "bg-dark", Square.light?(@square) && "bg-light"]}
    >
      <div class={[
        "absolute",
        "inset-0",
        @selected && Square.dark?(@square) && "backdrop-brightness-125",
        @selected && Square.light?(@square) && "backdrop-brightness-110"
      ]}>
        <div class={[
          "absolute",
          "inset-0",
          "w-full",
          "h-full",
        ]}>
        </div>
        <div class="absolute inset-0 w-full h-full cursor-pointer">
          <img
            class="absolute inset-0 w-full h-full cursor-pointer touch-none select-none"
            src={"/images/pieces/#{render_piece(@piece)}"}
            draggable="false"
          />
          <%= Square.to_square_index(@square) %>
        </div>
      </div>
    </div>
    """
  end

  # @highlighted && "bg-red-600/75",
  # @highlighted_ctrl && "bg-yellow-300/75",
  # @highlighted_alt && "bg-green-600/75"


  defp render_piece(:p), do: "b_p.svg"
  defp render_piece(:r), do: "b_r.svg"
  defp render_piece(:n), do: "b_n.svg"
  defp render_piece(:b), do: "b_b.svg"
  defp render_piece(:q), do: "b_q.svg"
  defp render_piece(:k), do: "b_k.svg"

  defp render_piece(:P), do: "w_p.svg"
  defp render_piece(:R), do: "w_r.svg"
  defp render_piece(:N), do: "w_n.svg"
  defp render_piece(:B), do: "w_b.svg"
  defp render_piece(:Q), do: "w_q.svg"
  defp render_piece(:K), do: "w_k.svg"

  defp render_piece(:empty), do: "none.svg"
end
