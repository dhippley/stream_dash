# StreamDash

**StreamDash** is a real-time dashboard built with Phoenix LiveView. It displays live event data as it's ingested by the backend, demonstrating a fully reactive system using Elixir, Phoenix PubSub, and GenStage.

---

## 💡 What It Does

- Simulates a stream of real-time data (telemetry, bids, or custom events)
- Renders incoming events in a live-updating dashboard via LiveView
- Supports event filtering, alert thresholds, and custom styling
- Includes Telemetry instrumentation for backend event throughput
- Designed to demonstrate LiveView UI patterns + real-time pipelines

---

## 🛠️ Tech Stack

- Phoenix LiveView
- Phoenix PubSub
- GenStage (optional)
- TailwindCSS (included via Phoenix installer)
- Telemetry

---

## 🚀 Getting Started

### Prerequisites
- Elixir 1.14+ and Erlang/OTP 25+
- Node.js 16+ (for asset compilation)

### Installation

```bash
git clone https://github.com/yourusername/stream_dash
cd stream_dash

# Install Elixir dependencies
mix deps.get

# Install Node.js dependencies for assets
cd assets && npm install && cd ..

# Start the Phoenix server
mix phx.server
```

Open http://localhost:4000 to view the dashboard.

### Features

✅ **Real-time Event Streaming** - Live events generated via GenStage  
✅ **Interactive Dashboard** - Phoenix LiveView with real-time updates  
✅ **Event Filtering** - Filter by event type (telemetry, bids, user actions)  
✅ **Smart Alerts** - Automatic alerts based on thresholds  
✅ **Performance Metrics** - Real-time stats and counters  
✅ **Responsive Design** - TailwindCSS styling  
✅ **Telemetry Integration** - Custom metrics and instrumentation  

### Event Types

- **Telemetry Events**: CPU usage, memory usage, response times, RPS
- **Bid Events**: Auction bids with amounts and participants  
- **Alert Events**: System alerts with different severity levels
- **User Action Events**: User interactions and page views

### Alert Thresholds

- CPU Usage > 90% → High priority alert
- Response Time > 400ms → Medium priority alert
- Memory Usage > 95% → High priority alert

---

## 🔧 Configuration

Event generation can be customized in `config/config.exs`:

```elixir
config :stream_dash,
  event_interval: 1000..3000,  # Event generation interval (ms)
  max_events: 50,              # Max events displayed
  max_alerts: 10               # Max alerts displayed
```

---

## 📊 Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   DataStream    │───▶│    EventBus      │───▶│  DashboardLive  │
│   (GenStage)    │    │   (PubSub)       │    │   (LiveView)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Telemetry     │    │  Alert System    │    │   Web Browser   │
│ Instrumentation │    │   (Automatic)    │    │  (Real-time UI) │  
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---
`

