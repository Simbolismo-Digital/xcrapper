defmodule XcrapperWeb.SessionLive.Post do
  use XcrapperWeb, :live_view

  alias Xcrapper.Account
  alias Xcrapper.Repo
  alias Xcrapper.User

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

  def handle_params(_params, _uri, socket) do
    if socket.assigns.logged_in do
      {:noreply, redirect(socket, to: "/pages")}
    else
      {:noreply, socket}
    end
  end

  def handle_event("login", %{"username" => username, "password" => password}, socket) do
    case User |> Repo.get_by(username: username) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid username or password")}

      user ->
        if User.check_password(user, password) do
          {:noreply,
           socket
           |> put_flash(:token, Account.login!(user.id))
           |> put_flash(:info, "Successfully logged in")
           |> redirect(to: "/pages")}
        else
          {:noreply, put_flash(socket, :error, "Invalid username or password")}
        end
    end
  end

  def handle_event("register", %{"username" => username, "password" => password}, socket) do
    with %{valid?: true} = changeset <-
           User.changeset(%User{}, %{username: username, password_hash: password}),
         {:ok, user} <- Repo.insert(changeset) do
      {:noreply,
       socket
       |> put_flash(:user_id, Account.login!(user.id))
       |> put_flash(:info, "Successfully registered")
       |> redirect(to: "/pages")}
    else
      _ ->
        {:noreply, put_flash(socket, :error, "Cannot create user, try another username")}
    end
  end
end
