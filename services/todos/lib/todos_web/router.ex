defmodule TodosAppWeb.Router do
  use TodosAppWeb, :router

  import TodosAppWeb.Accounts.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodosAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", TodosAppWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  # Other scopes may use custom stacks.
  # scope "/api", TodosAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todos, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodosAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/auth", TodosAppWeb.Accounts, as: :accounts do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TodosAppWeb.Accounts.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/register", UserRegistrationLive, :new
      live "/log_in", UserLoginLive, :new
      live "/reset_password", UserForgotPasswordLive, :new
      live "/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/log_in", UserSessionController, :create
  end

  live_session :auth,
    on_mount: [
      {TodosAppWeb.Accounts.UserAuth, :ensure_authenticated},
      {TodosAppWeb.UserLiveAuth, :default}
    ] do
    scope "/", TodosAppWeb.Todos, as: :todos do
      pipe_through [:browser, :require_authenticated_user]
      live "/", TaskLive.Index, :index
    end

    scope "/todos", TodosAppWeb.Todos, as: :todos do
      pipe_through [:browser, :require_authenticated_user]

      live "/", TaskLive.Index, :index
      live "/new", TaskLive.Index, :new
      live "/:id/edit", TaskLive.Index, :edit
      live "/:id", TaskLive.Show, :show
      live "/:id/show/edit", TaskLive.Show, :edit
    end
  end

  scope "/auth", TodosAppWeb.Accounts, as: :accounts do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TodosAppWeb.Accounts.UserAuth, :ensure_authenticated}] do
      live "/settings", UserSettingsLive, :edit
      live "/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/auth", TodosAppWeb.Accounts, as: :accounts do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{TodosAppWeb.Accounts.UserAuth, :mount_current_user}] do
      live "/confirm/:token", UserConfirmationLive, :edit
      live "/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
