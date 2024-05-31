defmodule Xcrapper.PageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xcrapper.Page` context.
  """

  alias Xcrapper.User
  alias Xcrapper.Repo

  def create_user_fixture(attrs \\ %{id: 1, username: "johnsnow", password_hash: "targaryen"}) do
    Repo.get(User, 1) ||
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert!()
  end

  @doc """
  Generate a live_page.
  """
  def live_page_fixture(attrs \\ %{}) do
    user = create_user_fixture()

    {:ok, live_page} =
      attrs
      |> Enum.into(%{
        title: "some title",
        url: "some url",
        user_id: user.id
      })
      |> Xcrapper.Page.create_live_page()

    live_page
  end
end
