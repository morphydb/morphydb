defmodule Game do
  alias Game.GameSupervisor
  alias Game.GameCode
  alias Phoenix.PubSub

  @pubsub Chess.PubSub
  @registry :game_registry

  def subscribe(%GameCode{game_id: game_id}) do
    :ok = PubSub.subscribe(@pubsub, game_id)
  end

  def new(), do: new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

  def new(fen) do
    game_code = GameCode.new()

    GameSupervisor.start_child({via_tuple(game_code), fen})

    game_code
  end

  def join(%GameCode{} = game_code), do: get_position(game_code)

  def get_position(%GameCode{} = game_code) do
    call_by_code(game_code, :get_position)
  end

  def highlight(%GameCode{} = game_code, square_index, modifier \\ :none) do
    cast_by_code(game_code, {:highlight, square_index, modifier})
  end

  def clear(%GameCode{} = game_code) do
    cast_by_code(game_code, :clear)
  end

  def arrow(%GameCode{} = game_code, %{from: from, to: to}) do
    cast_by_code(game_code, {:arrow, from, to})
  end

  defp whereis(%GameCode{} = game_code) do
    case Registry.lookup(@registry, game_code) do
      [{pid, nil}] -> pid
      [] -> nil
    end
  end

  defp call_by_code(%GameCode{} = game_code, message) do
    case whereis(game_code) do
      nil ->
        {:error, :game_not_found}

      _pid ->
        {:ok,
         game_code
         |> via_tuple()
         |> GenServer.call(message)}
    end
  end

  defp cast_by_code(%GameCode{} = game_code, message) do
    case whereis(game_code) do
      nil ->
        {:error, :game_not_found}

      _pid ->
        {:ok,
         game_code
         |> via_tuple()
         |> GenServer.cast(message)}
        |> broadcast(game_code)
    end
  end

  defp via_tuple(%GameCode{} = game_code),
    do: {:via, Registry, {@registry, game_code}}

  defp broadcast(result, %GameCode{game_id: game_id}) do
    PubSub.broadcast(@pubsub, game_id, {:updated})

    result
  end
end
