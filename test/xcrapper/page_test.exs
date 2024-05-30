defmodule Xcrapper.PageTest do
  use Xcrapper.DataCase

  alias Xcrapper.Page
  alias Xcrapper.Repo

  describe "pages" do
    alias Xcrapper.Page.LivePage

    import Xcrapper.PageFixtures

    @invalid_attrs %{title: nil, url: nil}

    test "list_pages/0 returns all pages" do
      live_page = live_page_fixture()
      assert Page.list_pages() == [live_page]
    end

    test "get_live_page!/1 returns the live_page with given id" do
      live_page = live_page_fixture() |> Repo.preload(:page_links)
      assert Page.get_live_page!(live_page.id) == live_page
    end

    test "create_live_page/1 with valid data creates a live_page" do
      valid_attrs = %{title: "some title", url: "some url"}

      assert {:ok, %LivePage{} = live_page} = Page.create_live_page(valid_attrs)
      assert live_page.title == "some title"
      assert live_page.url == "some url"
    end

    test "create_live_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Page.create_live_page(@invalid_attrs)
    end

    test "update_live_page/2 with valid data updates the live_page" do
      live_page = live_page_fixture()
      update_attrs = %{title: "some updated title", url: "some updated url"}

      assert {:ok, %LivePage{} = live_page} = Page.update_live_page(live_page, update_attrs)
      assert live_page.title == "some updated title"
      assert live_page.url == "some updated url"
    end

    test "update_live_page/2 with invalid data returns error changeset" do
      live_page = live_page_fixture() |> Repo.preload(:page_links)
      assert {:error, %Ecto.Changeset{}} = Page.update_live_page(live_page, @invalid_attrs)
      assert live_page == Page.get_live_page!(live_page.id)
    end

    test "delete_live_page/1 deletes the live_page" do
      live_page = live_page_fixture()
      assert {:ok, %LivePage{}} = Page.delete_live_page(live_page)
      assert_raise Ecto.NoResultsError, fn -> Page.get_live_page!(live_page.id) end
    end

    test "change_live_page/1 returns a live_page changeset" do
      live_page = live_page_fixture()
      assert %Ecto.Changeset{} = Page.change_live_page(live_page)
    end
  end
end
