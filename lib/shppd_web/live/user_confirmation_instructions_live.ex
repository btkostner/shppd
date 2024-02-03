defmodule ShppdWeb.UserConfirmationInstructionsLive do
  use ShppdWeb, :live_view

  alias Shppd.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <Components.header class="text-center">
        No confirmation instructions received?
        <:subtitle>We'll send a new confirmation link to your inbox</:subtitle>
      </Components.header>

      <Components.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <Components.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <Components.button phx-disable-with="Sending..." class="w-full">
            Resend confirmation instructions
          </Components.button>
        </:actions>
      </Components.simple_form>

      <p class="mt-4 text-center">
        <.link href={~p"/register"}>Register</.link> | <.link href={~p"/login"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user")),
     layout: {ShppdWeb.Layouts, :authentication}}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
