defmodule XcrapperWeb.LivePageLive.Index do
  use XcrapperWeb, :live_view

  alias Xcrapper.Page
  alias Xcrapper.Page.LivePage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pages, Page.list_pages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Live page")
    |> assign(:live_page, Page.get_live_page!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Live page")
    |> assign(:live_page, %LivePage{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pages")
    |> assign(:live_page, nil)
  end

  @impl true
  def handle_info({XcrapperWeb.LivePageLive.FormComponent, {:saved, live_page}}, socket) do
    {:noreply, stream_insert(socket, :pages, live_page)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    live_page = Page.get_live_page!(id)
    {:ok, _} = Page.delete_live_page(live_page)

    {:noreply, stream_delete(socket, :pages, live_page)}
  end
end
