defmodule ChessWeb.PageLive do
  use ChessWeb, :live_view

  alias ChessWeb.Components.GameComponent
  alias Game.GameCode

  def render(assigns) do
    ~H"""
    <.live_component module={GameComponent} id="game" game_code={@game_code} />
    """
  end

  def handle_params(%{"game_id" => game_id} = _params, _uri, socket) do
    game_code = GameCode.create(game_id)

    case Game.get_position(game_code) do
      {:error, :game_not_found} -> {:noreply, push_redirect(socket, to: ~p(/))}

      {:ok, _position} ->
        Game.subscribe(game_code)

        {:noreply,
         socket
         |> assign(:game_code, game_code)}
    end
  end

  def handle_params(_params, _url, socket) do
    game_code = Game.new()

    {:noreply, push_redirect(socket, to: ~p(/#{game_code.game_id}))}
  end

  def handle_info({:updated}, socket) do
    send_update(GameComponent, id: "game")
    {:noreply, socket}
  end

  def handle_event("load_fen", %{"fen" => fen}, socket) do
    game_code = Game.new(fen)

    {:noreply, push_patch(socket, to: ~p(/#{game_code.game_id}))}
  end
end
