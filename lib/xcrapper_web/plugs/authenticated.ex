defmodule XcrapperWeb.Plugs.Authenticated do
  @moduledoc """
  Plug to check if the user is authenticated
  """
  use Phoenix.Controller
  import Plug.Conn

  alias Xcrapper.Account

  def init(_), do: nil

  def call(conn, _opts) do
    conn =
      case get_in(conn.assigns, [:flash, "logout"]) do
        true -> clear_session(conn)
        _ -> conn
      end

    conn =
      case get_in(conn.assigns, [:flash, "token"]) do
        nil ->
          conn

        token ->
          {:ok, %{"user_id" => user_id}} = Account.decode(token)
          put_session(conn, :user_id, user_id)
      end

    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access this page")
        |> redirect(to: "/")

      _ ->
        conn
    end
  end
end
