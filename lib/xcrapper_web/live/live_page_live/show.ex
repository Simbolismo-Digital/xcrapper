defmodule XcrapperWeb.LivePageLive.Show do
  use XcrapperWeb, :live_view

  alias Xcrapper.Page

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:live_page, Page.get_live_page!(id))}
  end

  defp page_title(:show), do: "Show Live page"
  # defp page_title(:edit), do: "Edit Live page"
end
