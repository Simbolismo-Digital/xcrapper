defmodule Xcrapper.Scrapper do
  @moduledoc """
  Module to Scrap and update pages using :httpoison and :floki
  """
  import Ecto.Query

  alias Xcrapper.Page.LivePage
  alias Xcrapper.Repo

  def scrap_next_page() do
    with %LivePage{} = page <- next_page() do
      page
      |> fetch_page()
      |> parse_html()
      |> save_page(page)
    end
  end

  def next_page_query() do
    from(p in LivePage,
      where: is_nil(p.links),
      order_by: [asc: p.inserted_at],
      limit: 1,
      preload: :page_links
    )
  end

  def next_page() do
    next_page_query()
    |> Repo.one()
  end

  def fetch_page(%LivePage{url: url}) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def parse_html({:ok, html}) do
    {:ok, document} = Floki.parse_document(html)
    title = Floki.find(document, "title") |> Floki.text()

    links =
      Floki.find(document, "a")
      |> Enum.map(fn link ->
        href = Floki.attribute(link, "href") |> List.first()
        text = Floki.text(link) |> :binary.bin_to_list() |> List.to_string()
        %{href: href, text: text}
      end)

    {:ok, title, links}
  end

  def parse_html(error), do: error

  def save_page({:ok, title, links}, page) do
    LivePage.changeset(page, %{title: title, links: length(links), page_links: links})
    |> Repo.update()
  end

  def save_page({:error, error}, page) do
    LivePage.changeset(page, %{title: "Error #{error}", links: 0})
    |> Repo.update()
  end
end
