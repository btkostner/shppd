defmodule Shppd.PackagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shppd.Packages` context.
  """

  @doc """
  Generate a tracker.
  """
  def tracker_fixture(attrs \\ %{}) do
    {:ok, tracker} =
      attrs
      |> Enum.into(%{
        value: "some value"
      })
      |> Shppd.Packages.create_tracker()

    tracker
  end
end
