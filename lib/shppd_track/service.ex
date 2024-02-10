defmodule ShppdTrack.Service do
  @moduledoc """
  A behaviour for package tracking services like UPS, USPS, and FedEx.
  """

  @doc """
  Returns a human friendly name for the service.
  """
  @callback friendly_name(ShppdTrack.tracking_number()) :: binary()

  @doc """
  Checks if a given tracking number is possibly a valid
  tracking number. This is usually done via RegEx to prevent
  making an HTTP request to the service. It does not guarantee
  that the tracking number is valid.
  """
  @callback valid_tracking_number?(ShppdTrack.tracking_number()) :: boolean()

  @doc """
  Returns a human friendly URL for tracking the package.
  """
  @callback tracking_url(ShppdTrack.tracking_number()) :: binary()

  @doc """
  Returns tracking information for the package.
  """
  @callback get_tracking_info(ShppdTrack.tracking_number()) ::
              {:ok, ShppdTrack.Info.t()} | {:error, term()}
end
