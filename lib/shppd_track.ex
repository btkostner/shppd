defmodule ShppdTrack do
  @moduledoc """
  Gathers package tracking information from third
  parties via web scraping or API calls.
  """

  @services [
    ShppdTrack.Service.FedEx
  ]

  @typedoc """
  An Elixir module that implements the `ShppdTrack.Service`
  protocol.
  """
  @type service :: module()

  @typedoc """
  A user facing tracking number.
  """
  @type tracking_number :: binary()

  @doc """
  Returns a list of known Elixir modules that implement the
  `ShppdTrack.Service` protocol.
  """
  @spec services() :: [service()]
  def services(), do: @services

  @doc """
  Returns a list of known Elixir modules that implement the
  `ShppdTrack.Service` protocol and recognizes the given
  tracking number as valid.
  """
  @spec get_tracking_number_service(tracking_number()) :: service() | nil
  def get_tracking_number_service(tracking_number) do
    Enum.find(@services, fn service ->
      service.valid_tracking_number?(tracking_number)
    end)
  end

  @doc """
  Checks if the given tracking number is valid.
  """
  @spec valid_tracking_number?(tracking_number()) :: boolean()
  def valid_tracking_number?(tracking_number) do
    Enum.any?(@services, fn service ->
      service.valid_tracking_number?(tracking_number)
    end)
  end

  @doc """
  Gets tracking information for a tracking number. This
  will iterate over all known package services and attempt
  to find a service that recognizes that tracking number.
  If no service can be found, or if the tracking number
  can not be found, `nil` will be returned.
  """
  @spec get_tracking_info(tracking_number()) :: nil | ShppdTrack.Info.t()
  def get_tracking_info(tracking_number) do
    with service when is_atom(service) <- get_tracking_number_service(tracking_number) do
      service.get_tracking_info(tracking_number)
    end
  end

  @doc """
  Gets tracking information from the specified service.
  It will return `nil` if the package can not be found.
  """
  @spec get_tracking_info(service(), tracking_number()) :: nil | ShppdTrack.Info.t()
  def get_tracking_info(service, tracking_number) when is_atom(service) do
    service.get_tracking_info(tracking_number)
  end
end
