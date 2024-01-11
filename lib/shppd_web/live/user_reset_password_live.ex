defmodule ShppdWeb.UserResetPasswordLive do
  use ShppdWeb, :live_view

  alias Shppd.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <CoreComponents.header class="text-center">Reset Password</CoreComponents.header>

      <CoreComponents.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <CoreComponents.error :if={@form.errors != []}>
          Oops, something went wrong! Please check the errors below.
        </CoreComponents.error>

        <CoreComponents.input field={@form[:password]} type="password" label="New password" required />
        <CoreComponents.input
          field={@form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          required
        />
        <:actions>
          <CoreComponents.button phx-disable-with="Resetting..." class="w-full">
            Reset Password
          </CoreComponents.button>
        </:actions>
      </CoreComponents.simple_form>

      <p class="mt-4 text-center text-sm">
        <.link href={~p"/register"}>Register</.link> | <.link href={~p"/login"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source),
     temporary_assigns: [form: nil], layout: {ShppdWeb.Layouts, :authentication}}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/login")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
