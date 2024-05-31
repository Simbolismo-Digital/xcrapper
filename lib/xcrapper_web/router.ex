defmodule XcrapperWeb.Router do
  use XcrapperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {XcrapperWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug XcrapperWeb.Plugs.Authenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", XcrapperWeb do
    pipe_through :browser

    live "/", SessionLive.Post, :post
    live "/logout", SessionLive.Delete, :logout

    pipe_through :authenticated

    live "/pages", LivePageLive.Index, :index
    live "/pages/new", LivePageLive.Index, :new
    live "/pages/:id/edit", LivePageLive.Index, :edit

    live "/pages/:id", LivePageLive.Show, :show
    live "/pages/:id/show/edit", LivePageLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", XcrapperWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:xcrapper, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: XcrapperWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
