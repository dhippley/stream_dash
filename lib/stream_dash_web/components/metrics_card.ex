defmodule StreamDashWeb.Components.MetricsCard do
  @moduledoc """
  Reusable component for displaying metrics cards with icons and trends.
  """

  use Phoenix.Component

  attr :title, :string, required: true
  attr :value, :any, required: true
  attr :icon, :string, required: true
  attr :color, :string, default: "blue"
  attr :trend, :string, default: nil
  attr :trend_value, :string, default: nil

  def metrics_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow p-6 hover:shadow-lg transition-shadow">
      <div class="flex items-center">
        <div class="flex-shrink-0">
          <div class={"w-10 h-10 bg-#{@color}-500 rounded-md flex items-center justify-center"}>
            <span class="text-white text-lg font-bold"><%= @icon %></span>
          </div>
        </div>
        <div class="ml-4 flex-1">
          <p class="text-sm font-medium text-gray-500"><%= @title %></p>
          <div class="flex items-center justify-between">
            <p class="text-2xl font-semibold text-gray-900"><%= @value %></p>
            <%= if @trend do %>
              <div class={"flex items-center text-sm #{if @trend == "up", do: "text-green-600", else: "text-red-600"}"}>
                <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                  <%= if @trend == "up" do %>
                    <path fill-rule="evenodd" d="M5.293 7.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 5.414V17a1 1 0 11-2 0V5.414L6.707 7.707a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                  <% else %>
                    <path fill-rule="evenodd" d="M14.707 12.293a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 111.414-1.414L9 14.586V3a1 1 0 012 0v11.586l2.293-2.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                  <% end %>
                </svg>
                <span><%= @trend_value %></span>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
