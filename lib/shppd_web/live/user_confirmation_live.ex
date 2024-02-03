defmodule ShppdWeb.UserConfirmationLive do
  use ShppdWeb, :live_view

  alias Shppd.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <Components.header class="text-center">Confirm Account</Components.header>

      <Components.simple_form for={@form} id="confirmation_form" phx-submit="confirm_account">
        <Components.input field={@form[:token]} type="hidden" />
        <:actions>
          <Components.button phx-disable-with="Confirming..." class="w-full">
            Confirm my account
          </Components.button>
        </:actions>
      </Components.simple_form>

      <p class="mt-4 text-center">
        <.link href={~p"/register"}>Register</.link> | <.link href={~p"/login"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")

    {:ok, assign(socket, form: form),
     temporary_assigns: [form: nil], layout: {ShppdWeb.Layouts, :authentication}}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
