defmodule XcrapperWeb.LivePageLive.FormComponent do
  use XcrapperWeb, :live_component

  alias Xcrapper.Page

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage live_page records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="live_page-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%!-- <.input field={@form[:title]} type="text" label="Title" /> --%>
        <.input field={@form[:url]} type="text" label="Url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Live page</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{live_page: live_page} = assigns, socket) do
    changeset = Page.change_live_page(live_page)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"live_page" => live_page_params}, socket) do
    changeset =
      socket.assigns.live_page
      |> Page.change_live_page(live_page_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"live_page" => live_page_params}, socket) do
    save_live_page(socket, socket.assigns.action, live_page_params)
  end

  defp save_live_page(socket, :edit, live_page_params) do
    case Page.update_live_page(socket.assigns.live_page, live_page_params) do
      {:ok, live_page} ->
        notify_parent({:saved, live_page})

        {:noreply,
         socket
         |> put_flash(:info, "Live page updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_live_page(socket, :new, live_page_params) do
    case Page.create_live_page(live_page_params) do
      {:ok, live_page} ->
        notify_parent({:saved, live_page})

        {:noreply,
         socket
         |> put_flash(:info, "Live page created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
