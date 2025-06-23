defmodule StreamDash.Config do
  @moduledoc """
  Configuration settings for StreamDash application.
  """

  def event_generation_interval, do: Application.get_env(:stream_dash, :event_interval, 1000..3000)

  def max_events_displayed, do: Application.get_env(:stream_dash, :max_events, 50)

  def max_alerts_displayed, do: Application.get_env(:stream_dash, :max_alerts, 10)

  def alert_thresholds do
    %{
      cpu_usage: 90,
      memory_usage: 95,
      response_time: 400
    }
  end

  def event_types, do: [:telemetry, :bid, :alert, :user_action]
end
