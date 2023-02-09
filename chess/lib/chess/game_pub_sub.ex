defmodule Chess.GamePubSub do
  alias Phoenix.PubSub
  @pubsub Chess.PubSub

  def subscribe(room_id), do: PubSub.subscribe(@pubsub, topic(room_id))

  def unsubscribe(room_id), do: PubSub.unsubscribe(@pubsub, topic(room_id))

  def publish(room_id, message), do: PubSub.broadcast(@pubsub, topic(room_id), message)

  defp topic(room_id), do: "rooms:#{room_id}"
end
