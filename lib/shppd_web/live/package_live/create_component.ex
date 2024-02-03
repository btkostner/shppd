defmodule ShppdWeb.PackageLive.CreateComponent do
  use ShppdWeb, :live_component

  alias Shppd.Packages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <Components.header>
        Add a package
        <:subtitle>Use this form to track a new package.</:subtitle>
      </Components.header>

      <Components.simple_form
        for={@form}
        id="tracker-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <Components.input field={@form[:value]} type="text" label="Tracking Number" />
        <:actions>
          <Components.button phx-disable-with="Saving...">Track</Components.button>
        </:actions>
      </Components.simple_form>
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

  def handle_event("save", %{"tracker" => tracker_params}, socket) do
    case Packages.create_tracker(tracker_params) do
      {:ok, tracker} ->
        notify_parent({:saved, tracker})

        {:noreply,
         socket
         |> put_flash(:info, "Package added successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
