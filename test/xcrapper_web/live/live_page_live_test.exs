defmodule XcrapperWeb.LivePageLiveTest do
  use XcrapperWeb.ConnCase

  import Phoenix.LiveViewTest
  import Xcrapper.PageFixtures

  @create_attrs %{title: "some title", url: "some url"}
  @update_attrs %{title: "some updated title", url: "some updated url"}
  @invalid_attrs %{title: nil, url: nil}

  defp create_live_page(_) do
    live_page = live_page_fixture()
    %{live_page: live_page}
  end

  describe "Index" do
    setup [:create_live_page]

    test "lists all pages", %{conn: conn, live_page: live_page} do
      {:ok, _index_live, html} = live(conn, ~p"/pages")

      assert html =~ "Listing Pages"
      assert html =~ live_page.title
    end

    test "saves new live_page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pages")

      assert index_live |> element("a", "New Live page") |> render_click() =~
               "New Live page"

      assert_patch(index_live, ~p"/pages/new")

      assert index_live
             |> form("#live_page-form", live_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#live_page-form", live_page: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pages")

      html = render(index_live)
      assert html =~ "Live page created successfully"
      assert html =~ "some title"
    end

    test "updates live_page in listing", %{conn: conn, live_page: live_page} do
      {:ok, index_live, _html} = live(conn, ~p"/pages")

      assert index_live |> element("#pages-#{live_page.id} a", "Edit") |> render_click() =~
               "Edit Live page"

      assert_patch(index_live, ~p"/pages/#{live_page}/edit")

      assert index_live
             |> form("#live_page-form", live_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#live_page-form", live_page: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pages")

      html = render(index_live)
      assert html =~ "Live page updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes live_page in listing", %{conn: conn, live_page: live_page} do
      {:ok, index_live, _html} = live(conn, ~p"/pages")

      assert index_live |> element("#pages-#{live_page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pages-#{live_page.id}")
    end
  end

  describe "Show" do
    setup [:create_live_page]

    test "displays live_page", %{conn: conn, live_page: live_page} do
      {:ok, _show_live, html} = live(conn, ~p"/pages/#{live_page}")

      assert html =~ "Show Live page"
      assert html =~ live_page.title
    end

    test "updates live_page within modal", %{conn: conn, live_page: live_page} do
      {:ok, show_live, _html} = live(conn, ~p"/pages/#{live_page}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Live page"

      assert_patch(show_live, ~p"/pages/#{live_page}/show/edit")

      assert show_live
             |> form("#live_page-form", live_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#live_page-form", live_page: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pages/#{live_page}")

      html = render(show_live)
      assert html =~ "Live page updated successfully"
      assert html =~ "some updated title"
    end
  end
end
