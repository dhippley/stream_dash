defmodule StreamDashWeb.DashboardLive do
  @moduledoc """
  Main dashboard LiveView that displays real-time events and metrics.
  """

  use StreamDashWeb, :live_view
  alias StreamDash.EventBus

  @max_events 50

  def mount(_params, _session, socket) do
    if connected?(socket) do
      EventBus.subscribe()
    end

    socket =
      socket
      |> assign(:events, [])
      |> assign(:alerts, [])
      |> assign(:filter, :all)
      |> assign(:stats, initial_stats())
      |> assign(:page_title, "StreamDash - Real-time Dashboard")

    {:ok, socket}
  end

  def handle_info({:new_event, event}, socket) do
    events = [event | socket.assigns.events] |> Enum.take(@max_events)
    stats = update_stats(socket.assigns.stats, event)

    socket =
      socket
      |> assign(:events, events)
      |> assign(:stats, stats)

    {:noreply, socket}
  end

  def handle_info({:alert, alert}, socket) do
    alerts = [alert | socket.assigns.alerts] |> Enum.take(10)

    socket = assign(socket, :alerts, alerts)
    {:noreply, socket}
  end

  def handle_event("filter", %{"type" => type}, socket) do
    filter = String.to_existing_atom(type)
    {:noreply, assign(socket, :filter, filter)}
  end

  def handle_event("clear_alerts", _params, socket) do
    {:noreply, assign(socket, :alerts, [])}
  end

  def handle_event("clear_events", _params, socket) do
    {:noreply, assign(socket, :events, [])}
  end

  defp filtered_events(events, :all), do: events
  defp filtered_events(events, filter) do
    Enum.filter(events, &(&1.type == filter))
  end

  defp initial_stats do
    %{
      total_events: 0,
      telemetry_count: 0,
      bid_count: 0,
      alert_count: 0,
      user_action_count: 0,
      avg_response_time: 0,
      last_updated: DateTime.utc_now()
    }
  end

  defp update_stats(stats, event) do
    type_key = :"#{event.type}_count"
    new_stats = %{
      stats |
      total_events: stats.total_events + 1,
      last_updated: DateTime.utc_now()
    }

    new_stats = Map.update(new_stats, type_key, 1, &(&1 + 1))

    # Update average response time for telemetry events
    case event do
      %{type: :telemetry, data: %{response_time: rt}} ->
        current_avg = stats.avg_response_time
        count = stats.telemetry_count
        new_avg = if count == 0, do: rt, else: (current_avg * count + rt) / (count + 1)
        Map.put(new_stats, :avg_response_time, Float.round(new_avg, 2))
      _ ->
        new_stats
    end
  end

  defp event_color(:telemetry), do: "bg-blue-100 border-blue-500 text-blue-900"
  defp event_color(:bid), do: "bg-green-100 border-green-500 text-green-900"
  defp event_color(:alert), do: "bg-red-100 border-red-500 text-red-900"
  defp event_color(:user_action), do: "bg-purple-100 border-purple-500 text-purple-900"

  defp alert_color(:low), do: "bg-yellow-100 border-yellow-500 text-yellow-800"
  defp alert_color(:medium), do: "bg-orange-100 border-orange-500 text-orange-800"
  defp alert_color(:high), do: "bg-red-100 border-red-500 text-red-800"
  defp alert_color(:critical), do: "bg-red-200 border-red-600 text-red-900 font-bold"

  defp format_timestamp(timestamp) do
    timestamp
    |> DateTime.to_time()
    |> Time.to_string()
    |> String.slice(0, 8)
  end

  defp format_event_data(%{type: :telemetry, data: data}) do
    "CPU: #{data.cpu_usage}% | Memory: #{data.memory_usage}% | Response: #{data.response_time}ms | RPS: #{data.requests_per_second}"
  end

  defp format_event_data(%{type: :bid, data: data}) do
    "$#{data.amount} by #{data.bidder_id} for #{data.item_id}"
  end

  defp format_event_data(%{type: :alert, data: data}) do
    "#{String.upcase(to_string(data.severity))}: #{data.message} (#{data.source})"
  end

  defp format_event_data(%{type: :user_action, data: data}) do
    "#{data.user_id} performed '#{data.action}' on #{data.page}"
  end
end
