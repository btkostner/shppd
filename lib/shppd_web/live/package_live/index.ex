defmodule ShppdWeb.PackageLive.Index do
  use ShppdWeb, :live_view

  alias Shppd.Packages
  alias Shppd.Packages.Tracker

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :trackers, Packages.list_trackers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Package")
    |> assign(:tracker, %Tracker{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Packages")
    |> assign(:tracker, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Package")
    |> assign(:tracker, Packages.get_tracker!(id))
  end

  @impl true
  def handle_info({ShppdWeb.PackageLive.CreateComponent, {:saved, tracker}}, socket) do
    {:noreply, stream_insert(socket, :trackers, tracker)}
  end

  @impl true
  def handle_info({ShppdWeb.PackageLive.ShowComponent, {:deleted, tracker}}, socket) do
    {:noreply, stream_delete(socket, :trackers, tracker)}
  end
end
