defmodule XcrapperWeb.SessionLive.Delete do
  use XcrapperWeb, :live_view

  def init(_params) do
    {:ok, %{}}
  end

  def call(conn, _params) do
    conn
  end

  def mount(_params, session, socket) do
    logged_in = Map.has_key?(session, "user_id")
    {:ok, assign(socket, %{logged_in: logged_in})}
  end

  def handle_event("logout", _params, socket) do
    {:noreply,
     socket |> assign(logged_in: false) |> put_flash(:logout, true) |> redirect(to: "/pages")}
  end
end
