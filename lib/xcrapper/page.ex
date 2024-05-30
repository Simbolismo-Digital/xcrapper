defmodule Xcrapper.Page do
  @moduledoc """
  The Page context.
  """

  import Ecto.Query, warn: false
  alias Xcrapper.Repo

  alias Xcrapper.Page.LivePage

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%LivePage{}, ...]

  """
  def list_pages do
    Repo.all(LivePage)
  end

  @doc """
  Gets a single live_page.

  Raises `Ecto.NoResultsError` if the Live page does not exist.

  ## Examples

      iex> get_live_page!(123)
      %LivePage{}

      iex> get_live_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_live_page!(id), do: Repo.get!(LivePage, id)

  @doc """
  Creates a live_page.

  ## Examples

      iex> create_live_page(%{field: value})
      {:ok, %LivePage{}}

      iex> create_live_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_live_page(attrs \\ %{}) do
    %LivePage{}
    |> LivePage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a live_page.

  ## Examples

      iex> update_live_page(live_page, %{field: new_value})
      {:ok, %LivePage{}}

      iex> update_live_page(live_page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_live_page(%LivePage{} = live_page, attrs) do
    live_page
    |> LivePage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a live_page.

  ## Examples

      iex> delete_live_page(live_page)
      {:ok, %LivePage{}}

      iex> delete_live_page(live_page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_live_page(%LivePage{} = live_page) do
    Repo.delete(live_page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking live_page changes.

  ## Examples

      iex> change_live_page(live_page)
      %Ecto.Changeset{data: %LivePage{}}

  """
  def change_live_page(%LivePage{} = live_page, attrs \\ %{}) do
    LivePage.changeset(live_page, attrs)
  end
end
