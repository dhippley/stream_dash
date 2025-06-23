defmodule StreamDash.EventBus do
  @moduledoc """
  EventBus handles the PubSub communication for real-time events.
  It broadcasts events to subscribed LiveView processes.
  """

  @topic "events"

  def subscribe do
    Phoenix.PubSub.subscribe(StreamDash.PubSub, @topic)
  end

  def broadcast_event(event) do
    Phoenix.PubSub.broadcast(StreamDash.PubSub, @topic, {:new_event, event})
  end

  def broadcast_alert(alert) do
    Phoenix.PubSub.broadcast(StreamDash.PubSub, @topic, {:alert, alert})
  end
end
