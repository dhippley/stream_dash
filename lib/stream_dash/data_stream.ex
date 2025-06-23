defmodule StreamDash.DataStream do
  @moduledoc """
  DataStream simulates real-time event generation using GenStage.
  It produces various types of events (telemetry, bids, custom) and broadcasts them.
  """

  use GenStage
  alias StreamDash.EventBus

  @event_types [:telemetry, :bid, :alert, :user_action]

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # Start with a small demand and schedule the first event
    schedule_next_event()
    {:producer, %{counter: 0}}
  end

  def handle_demand(demand, %{counter: counter} = state) when demand > 0 do
    events = generate_events(demand, counter)

    # Broadcast each event to the EventBus
    Enum.each(events, &EventBus.broadcast_event/1)

    {:noreply, events, %{state | counter: counter + demand}}
  end

  def handle_info(:generate_event, state) do
    # Generate a single event periodically
    event = generate_single_event(state.counter)
    EventBus.broadcast_event(event)

    # Add telemetry
    :telemetry.execute([:stream_dash, :event, :generated], %{count: 1}, %{type: event.type})

    # Schedule next event
    schedule_next_event()

    {:noreply, [], %{state | counter: state.counter + 1}}
  end

  defp schedule_next_event do
    # Generate events every 1-3 seconds
    delay = Enum.random(1000..3000)
    Process.send_after(self(), :generate_event, delay)
  end

  defp generate_events(count, start_counter) do
    for i <- 0..(count - 1) do
      generate_single_event(start_counter + i)
    end
  end

  defp generate_single_event(counter) do
    type = Enum.random(@event_types)

    base_event = %{
      id: counter,
      type: type,
      timestamp: DateTime.utc_now(),
      data: generate_event_data(type)
    }

    # Check for alert conditions
    maybe_add_alert(base_event)
  end

  defp generate_event_data(:telemetry) do
    %{
      cpu_usage: Enum.random(0..100),
      memory_usage: Enum.random(30..95),
      response_time: Enum.random(10..500),
      requests_per_second: Enum.random(1..1000)
    }
  end

  defp generate_event_data(:bid) do
    %{
      amount: Enum.random(100..10000) / 100,
      bidder_id: "user_#{Enum.random(1..100)}",
      item_id: "item_#{Enum.random(1..50)}",
      auction_id: "auction_#{Enum.random(1..10)}"
    }
  end

  defp generate_event_data(:alert) do
    severity = Enum.random([:low, :medium, :high, :critical])
    %{
      severity: severity,
      message: generate_alert_message(severity),
      source: Enum.random(["server-1", "server-2", "server-3", "database", "api"])
    }
  end

  defp generate_event_data(:user_action) do
    actions = ["login", "logout", "view_page", "click_button", "form_submit"]
    %{
      action: Enum.random(actions),
      user_id: "user_#{Enum.random(1..1000)}",
      page: "/#{Enum.random(["dashboard", "profile", "settings", "reports"])}"
    }
  end

  defp generate_alert_message(:low), do: "Low priority notification"
  defp generate_alert_message(:medium), do: "Medium priority warning"
  defp generate_alert_message(:high), do: "High priority alert!"
  defp generate_alert_message(:critical), do: "CRITICAL SYSTEM ALERT!"

  defp maybe_add_alert(%{type: :telemetry, data: %{cpu_usage: cpu}} = event) when cpu > 90 do
    alert = %{
      severity: :high,
      message: "High CPU usage detected: #{cpu}%",
      related_event_id: event.id
    }
    EventBus.broadcast_alert(alert)
    Map.put(event, :alert_triggered, true)
  end

  defp maybe_add_alert(%{type: :telemetry, data: %{response_time: time}} = event) when time > 400 do
    alert = %{
      severity: :medium,
      message: "Slow response time detected: #{time}ms",
      related_event_id: event.id
    }
    EventBus.broadcast_alert(alert)
    Map.put(event, :alert_triggered, true)
  end

  defp maybe_add_alert(event), do: event
end
