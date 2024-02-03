defmodule ShppdWeb.UserForgotPasswordLive do
  use ShppdWeb, :live_view

  alias Shppd.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <Components.header class="text-center">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </Components.header>

      <Components.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <Components.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <Components.button phx-disable-with="Sending..." class="w-full">
            Send password reset instructions
          </Components.button>
        </:actions>
      </Components.simple_form>
      <p class="mt-4 text-center text-sm">
        <.link href={~p"/register"}>Register</.link> | <.link href={~p"/login"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user")),
     layout: {ShppdWeb.Layouts, :authentication}}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/reset-password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
