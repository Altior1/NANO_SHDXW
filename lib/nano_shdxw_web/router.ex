defmodule NanoShdxwWeb.Router do
  use NanoShdxwWeb, :router

  import NanoShdxwWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NanoShdxwWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NanoShdxwWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", NanoShdxwWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:nano_shdxw, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NanoShdxwWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NanoShdxwWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{NanoShdxwWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit

    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", NanoShdxwWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{NanoShdxwWeb.UserAuth, :ensure_authenticated}] do

      # Reservation routes
      live "/reservations", ReservationLive.Index, :index
      live "/reservations/new", ReservationLive.Index, :new
      live "/reservations/:id/edit", ReservationLive.Index, :edit

      live "/reservations/:id", ReservationLive.Show, :show
      live "/reservations/:id/show/edit", ReservationLive.Show, :edit

      live "/reservations_calendar", ReservationCalendarLive
      get "/reservations_calendar/events", ReservationApiController, :events

      # Messagge routes
      live "/messages", MessageLive.Index, :index
      live "/messages/new", MessageLive.Index, :new
      live "/messages/:id/edit", MessageLive.Index, :edit

      live "/messages/:id", MessageLive.Show, :show
      live "/messages/:id/show/edit", MessageLive.Show, :edit

      # User routes
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", NanoShdxwWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{NanoShdxwWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
