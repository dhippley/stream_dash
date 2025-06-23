#!/usr/bin/env elixir

# StreamDash Demo Script
# This script demonstrates how to interact with the StreamDash system programmatically

Mix.install([
  {:jason, "~> 1.2"}
])

defmodule StreamDashDemo do
  @moduledoc """
  Demo script to showcase StreamDash capabilities.
  """

  def run do
    IO.puts("🚀 StreamDash Demo")
    IO.puts("==================")
    IO.puts("")

    IO.puts("✅ Features implemented:")
    IO.puts("   • Real-time event streaming with GenStage")
    IO.puts("   • Phoenix LiveView dashboard")
    IO.puts("   • Event filtering by type")
    IO.puts("   • Smart alert system")
    IO.puts("   • Performance metrics")
    IO.puts("   • Responsive TailwindCSS design")
    IO.puts("   • Telemetry instrumentation")
    IO.puts("")

    IO.puts("📊 Event Types:")
    IO.puts("   • Telemetry: CPU, Memory, Response times")
    IO.puts("   • Bids: Auction bid data")
    IO.puts("   • Alerts: System notifications")
    IO.puts("   • User Actions: User interactions")
    IO.puts("")

    IO.puts("🔗 Access the dashboard at: http://localhost:4000")
    IO.puts("")
    IO.puts("🎯 Try these features:")
    IO.puts("   1. Watch live events streaming in")
    IO.puts("   2. Filter events by type using the buttons")
    IO.puts("   3. Observe automatic alerts when thresholds are exceeded")
    IO.puts("   4. Monitor real-time statistics")
    IO.puts("   5. Clear events/alerts using the action buttons")
    IO.puts("")

    sample_event = %{
      id: 1,
      type: :telemetry,
      timestamp: DateTime.utc_now(),
      data: %{
        cpu_usage: 85,
        memory_usage: 70,
        response_time: 250,
        requests_per_second: 450
      }
    }

    IO.puts("📋 Sample Event Structure:")
    IO.puts(Jason.encode!(sample_event, pretty: true))
  end
end

StreamDashDemo.run()
