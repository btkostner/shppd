defmodule Shppd.PackagesTest do
  use Shppd.DataCase

  alias Shppd.Packages

  describe "trackers" do
    alias Shppd.Packages.Tracker

    import Shppd.PackagesFixtures

    @invalid_attrs %{value: nil}

    test "list_trackers/0 returns all trackers" do
      tracker = tracker_fixture()
      assert Packages.list_trackers() == [tracker]
    end

    test "get_tracker!/1 returns the tracker with given id" do
      tracker = tracker_fixture()
      assert Packages.get_tracker!(tracker.id) == tracker
    end

    test "create_tracker/1 with valid data creates a tracker" do
      valid_attrs = %{value: "some value"}

      assert {:ok, %Tracker{} = tracker} = Packages.create_tracker(valid_attrs)
      assert tracker.value == "some value"
    end

    test "create_tracker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Packages.create_tracker(@invalid_attrs)
    end

    test "update_tracker/2 with valid data updates the tracker" do
      tracker = tracker_fixture()
      update_attrs = %{value: "some updated value"}

      assert {:ok, %Tracker{} = tracker} = Packages.update_tracker(tracker, update_attrs)
      assert tracker.value == "some updated value"
    end

    test "update_tracker/2 with invalid data returns error changeset" do
      tracker = tracker_fixture()
      assert {:error, %Ecto.Changeset{}} = Packages.update_tracker(tracker, @invalid_attrs)
      assert tracker == Packages.get_tracker!(tracker.id)
    end

    test "delete_tracker/1 deletes the tracker" do
      tracker = tracker_fixture()
      assert {:ok, %Tracker{}} = Packages.delete_tracker(tracker)
      assert_raise Ecto.NoResultsError, fn -> Packages.get_tracker!(tracker.id) end
    end

    test "change_tracker/1 returns a tracker changeset" do
      tracker = tracker_fixture()
      assert %Ecto.Changeset{} = Packages.change_tracker(tracker)
    end
  end
end
