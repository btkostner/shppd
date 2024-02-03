defmodule ShppdWeb.Router do
  use ShppdWeb, :router

  import ShppdWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ShppdWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:shppd, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ShppdWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", ShppdWeb do
    pipe_through :browser

    get "/", MarketingController, :homepage
  end

  scope "/", ShppdWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ShppdWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/register", UserRegistrationLive, :new
      live "/login", UserLoginLive, :new
      live "/reset-password", UserForgotPasswordLive, :new
      live "/reset-password/:token", UserResetPasswordLive, :edit
    end

    post "/login", UserSessionController, :create
  end

  scope "/", ShppdWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ShppdWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm-email/:token", UserSettingsLive, :confirm_email

      live "/packages", PackageLive.Index, :index
      live "/packages/new", PackageLive.Index, :new
      live "/packages/:id", PackageLive.Index, :show
    end
  end

  scope "/", ShppdWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ShppdWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShppdWeb do
  #   pipe_through :api
  # end
end
