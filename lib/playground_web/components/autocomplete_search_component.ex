defmodule PlaygroundWeb.AutocompleteSearchComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex flex-col py-8 px-16" id="{id}" x-data="{ open: false }">
      <label class="text-lg text-grey-500 font-bold pb-2">Search:</label>
      <input
        class="border border-solid border-grey-700 rounded p-2"
        id="search-input"
        autocomplete="off"
        type="text"
        phx-keyup="search"
        x-on:keydown="open = true"
      />

      <div class="bg-white mt-2 rounded shadow" x-show="open" @click.away="open = false">
        <div class="p-4 pb-2 italic text-sm text-gray-400">
          <%= @items_count %> <%= Inflex.inflect("Results", @items_count) %>
        </div>
        <%= for item <- @items do %>
          <div
            class="px-4 py-2 cursor-pointer hover:bg-gray-100 first:pt-4 last:pb-4"
            phx-click="select-item"
            phx-target={@myself}
            phx-value-item={item}
          >
            <%= item %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("select-item", %{"item" => item}, socket) do
    send(self(), {:item_selected, item})
    {:noreply, socket}
  end
end
