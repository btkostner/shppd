defmodule ShppdWeb.UserRegistrationLive do
  use ShppdWeb, :live_view

  alias Shppd.Accounts
  alias Shppd.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <CoreComponents.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/login"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </CoreComponents.header>

      <CoreComponents.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/login?_action=registered"}
        method="post"
      >
        <CoreComponents.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </CoreComponents.error>

        <CoreComponents.input field={@form[:email]} type="email" label="Email" required />
        <CoreComponents.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <CoreComponents.button phx-disable-with="Creating account..." class="w-full">
            Create an account
          </CoreComponents.button>
        </:actions>
      </CoreComponents.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil], layout: {ShppdWeb.Layouts, :authentication}}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
