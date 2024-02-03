defmodule ShppdWeb.TrackerLiveTest do
  use ShppdWeb.ConnCase

  import Phoenix.LiveViewTest
  import Shppd.{AccountsFixtures, PackagesFixtures}

  @create_attrs %{value: "some value"}
  @invalid_attrs %{value: nil}

  setup %{conn: conn} do
    %{conn: log_in_user(conn, user_fixture())}
  end

  defp create_tracker(_) do
    tracker = tracker_fixture()
    %{tracker: tracker}
  end

  describe "Index" do
    setup [:create_tracker]

    test "lists all trackers", %{conn: conn, tracker: tracker} do
      {:ok, _index_live, html} = live(conn, ~p"/packages")

      assert html =~ "Value"
      assert html =~ tracker.value
    end

    test "redirects to new page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/packages")

      assert index_live |> element("a", "Add a Package") |> render_click()
      assert_redirect(index_live, ~p"/packages/new")
    end
  end

  describe "New" do
    test "saves new tracker", %{conn: conn} do
      {:ok, new_live, _html} = live(conn, ~p"/packages/new")

      assert new_live
             |> form("#tracker-form", tracker: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert new_live
             |> form("#tracker-form", tracker: @create_attrs)
             |> render_submit()

      assert_patch(new_live, ~p"/packages")

      html = render(new_live)
      assert html =~ "Package added successfully"
      assert html =~ "some value"
    end
  end

  describe "Show" do
    setup [:create_tracker]

    test "displays tracker", %{conn: conn, tracker: tracker} do
      {:ok, _show_live, html} = live(conn, ~p"/packages/#{tracker}")

      assert html =~ "Activity"
      assert html =~ tracker.value
    end

    test "deletes tracker in listing", %{conn: conn, tracker: tracker} do
      {:ok, show_live, _html} = live(conn, ~p"/packages/#{tracker}")

      assert show_live |> element("a", "Delete") |> render_click()
      refute has_element?(show_live, "#trackers-#{tracker.id}")
    end
  end
end
