defmodule ShppdWeb.PackageLive.ShowComponent do
  use ShppdWeb, :live_component

  alias Shppd.Packages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2 class="text-sm font-semibold leading-6 text-gray-900">Activity</h2>

      <ul role="list" class="mt-6 space-y-6">
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 -bottom-6 left-0 flex w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <div class="relative flex h-6 w-6 flex-none items-center justify-center bg-white">
            <div class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          </div>
          <p class="flex-auto py-0.5 text-xs leading-5 text-gray-500">
            <span class="font-medium text-gray-900">Chelsea Hagon</span> created the invoice.
          </p>
          <time datetime="2023-01-23T10:32" class="flex-none py-0.5 text-xs leading-5 text-gray-500">
            7d ago
          </time>
        </li>
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 -bottom-6 left-0 flex w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <div class="relative flex h-6 w-6 flex-none items-center justify-center bg-white">
            <div class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          </div>
          <p class="flex-auto py-0.5 text-xs leading-5 text-gray-500">
            <span class="font-medium text-gray-900">Chelsea Hagon</span> edited the invoice.
          </p>
          <time datetime="2023-01-23T11:03" class="flex-none py-0.5 text-xs leading-5 text-gray-500">
            6d ago
          </time>
        </li>
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 -bottom-6 left-0 flex w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <div class="relative flex h-6 w-6 flex-none items-center justify-center bg-white">
            <div class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          </div>
          <p class="flex-auto py-0.5 text-xs leading-5 text-gray-500">
            <span class="font-medium text-gray-900">Chelsea Hagon</span> sent the invoice.
          </p>
          <time datetime="2023-01-23T11:24" class="flex-none py-0.5 text-xs leading-5 text-gray-500">
            6d ago
          </time>
        </li>
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 -bottom-6 left-0 flex w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <img
            src="https://images.unsplash.com/photo-1550525811-e5869dd03032?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
            alt=""
            class="relative mt-3 h-6 w-6 flex-none rounded-full bg-gray-50"
          />
          <div class="flex-auto rounded-md p-3 ring-1 ring-inset ring-gray-200">
            <div class="flex justify-between gap-x-4">
              <div class="py-0.5 text-xs leading-5 text-gray-500">
                <span class="font-medium text-gray-900">Chelsea Hagon</span> commented
              </div>
              <time
                datetime="2023-01-23T15:56"
                class="flex-none py-0.5 text-xs leading-5 text-gray-500"
              >
                3d ago
              </time>
            </div>
            <p class="text-sm leading-6 text-gray-500">
              Called client, they reassured me the invoice would be paid by the 25th.
            </p>
          </div>
        </li>
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 -bottom-6 left-0 flex w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <div class="relative flex h-6 w-6 flex-none items-center justify-center bg-white">
            <div class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          </div>
          <p class="flex-auto py-0.5 text-xs leading-5 text-gray-500">
            <span class="font-medium text-gray-900">Alex Curren</span> viewed the invoice.
          </p>
          <time datetime="2023-01-24T09:12" class="flex-none py-0.5 text-xs leading-5 text-gray-500">
            2d ago
          </time>
        </li>
        <li class="relative flex gap-x-4">
          <div class="absolute top-0 left-0 flex h-6 w-6 justify-center">
            <div class="w-px bg-gray-200"></div>
          </div>
          <div class="relative flex h-6 w-6 flex-none items-center justify-center bg-white">
            <svg
              class="h-6 w-6 text-indigo-600"
              viewBox="0 0 24 24"
              fill="currentColor"
              aria-hidden="true"
            >
              <path
                fill-rule="evenodd"
                d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm13.36-1.814a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.75-5.25z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <p class="flex-auto py-0.5 text-xs leading-5 text-gray-500">
            <span class="font-medium text-gray-900">Alex Curren</span> paid the invoice.
          </p>
          <time datetime="2023-01-24T09:20" class="flex-none py-0.5 text-xs leading-5 text-gray-500">
            1d ago
          </time>
        </li>
      </ul>

      <.link phx-click={JS.push("delete")} phx-target={@myself} data-confirm="Are you sure?">
        Delete
      </.link>
    </div>
    """
  end

  @impl true
  def update(%{tracker: tracker} = assigns, socket) do
    changeset = Packages.change_tracker(tracker)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tracker" => tracker_params}, socket) do
    changeset =
      socket.assigns.tracker
      |> Packages.change_tracker(tracker_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"tracker" => tracker_params}, socket) do
    case Packages.update_tracker(socket.assigns.tracker, tracker_params) do
      {:ok, tracker} ->
        notify_parent({:saved, tracker})

        {:noreply,
         socket
         |> put_flash(:info, "Package updated")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("delete", %{}, socket) do
    case Packages.delete_tracker(socket.assigns.tracker) do
      {:ok, _} ->
        notify_parent({:deleted, socket.assigns.tracker})

        {:noreply,
         socket
         |> put_flash(:info, "Package deleted")
         |> push_patch(to: ~p"/packages")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
