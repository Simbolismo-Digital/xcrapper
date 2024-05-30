defmodule Xcrapper.PageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xcrapper.Page` context.
  """

  @doc """
  Generate a live_page.
  """
  def live_page_fixture(attrs \\ %{}) do
    {:ok, live_page} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url"
      })
      |> Xcrapper.Page.create_live_page()

    live_page
  end
end
