defmodule PlaygroundWeb.AutocompleteSearchController do
  use PlaygroundWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected_items, [])
      |> assign(:available_items, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"value" => ""}, socket) do
    {:noreply, assign(socket, :available_items, [])}
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    matched_items =
      list_items()
      |> then(fn items ->
        items -- socket.assigns.selected_items
      end)
      |> Enum.filter(&(String.downcase(&1) =~ String.downcase(value)))

    {:noreply, assign(socket, :available_items, matched_items)}
  end

  @impl true
  def handle_event("deselect-item", %{"item" => item}, socket) do
    socket =
      socket
      |> assign(:selected_items, socket.assigns.selected_items -- [item] |> Enum.sort())
      |> assign(:available_items, socket.assigns.available_items ++ [item])

    {:noreply, socket}
  end

  @impl true
  def handle_info({:item_selected, item}, socket) do
    socket =
      socket
      |> assign(:selected_items, socket.assigns.selected_items ++ [item] |> Enum.sort())
      |> assign(:available_items, socket.assigns.available_items -- [item])

    {:noreply, socket}
  end

  defp list_items do
    for letter <- ?A..?Z, number <- 1..9 do
      "Item #{letter |> List.wrap() |> List.to_string()}#{number}"
    end
  end
end
