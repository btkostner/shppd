defmodule ShppdWeb.UserLoginLive do
  use ShppdWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <CoreComponents.header class="text-center">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </CoreComponents.header>

      <CoreComponents.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
        <CoreComponents.input field={@form[:email]} type="email" label="Email" required />
        <CoreComponents.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <CoreComponents.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/reset-password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <CoreComponents.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </CoreComponents.button>
        </:actions>
      </CoreComponents.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form),
     temporary_assigns: [form: form], layout: {ShppdWeb.Layouts, :authentication}}
  end
end
