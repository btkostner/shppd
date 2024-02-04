defmodule ShppdTrack.Service.FedEx do
  @moduledoc """
  Tracking packages in the FedEx system.
  """

  alias ShppdTrack.Http

  @behaviour ShppdTrack.Service

  @doc """
  Returns a human friendly name for the service.
  """
  @impl ShppdTrack.Service
  def friendly_name(_tracking_number), do: "FedEx"

  @doc """
  Checks if a given tracking number is possibly
  a valid tracking number. This is done via
  a simple RegEx check and does not guarantee
  that the tracking number is valid.

  ## Examples

      iex> valid_tracking_number?("041441760228964")
      true

      iex> valid_tracking_number?("568283610012732")
      false

  """
  # TODO: We can probably do this faster with binary matching
  # instead of Regex.
  @impl ShppdTrack.Service
  def valid_tracking_number?(tracking_number) do
    cond do
      # FedEx Ground
      match = Regex.run(~r/^([0-9]{14})([0-9]{1})$/, tracking_number) ->
        [_full, serial_number, check_string] = match
        check_digit = String.to_integer(check_string)

        ShppdTrack.Checksum.valid_mod10?(serial_number, check_digit,
          evens_multiplier: 1,
          odds_multiplier: 3
        )

      # FedEx Ground (SSCC-18)
      match = Regex.run(~r/^([0-9]{2})([0-9]{15})([0-9]{1})$/, tracking_number) ->
        [_full, _shipping_container_type, serial_number, check_string] = match
        check_digit = String.to_integer(check_string)

        ShppdTrack.Checksum.valid_mod10?(serial_number, check_digit,
          evens_multiplier: 3,
          odds_multiplier: 1
        )

      # FedEx Ground 96 (22)
      match =
          Regex.run(~r/^(96)([0-9]{2})([0-9]{3})([0-9]{7})([0-9]{7})([0-9]{1})$/, tracking_number) ->
        [
          _full,
          _application_identifier,
          _scnc,
          _service_type,
          shipper_id,
          package_id,
          check_string
        ] = match

        check_digit = String.to_integer(check_string)

        ShppdTrack.Checksum.valid_mod10?(shipper_id <> package_id, check_digit,
          evens_multiplier: 1,
          odds_multiplier: 3
        )

      # FedEx Ground GSN
      match =
          Regex.run(
            ~r/^(96)([0-9]{2})([0-9]{5})([0-9]{10})([0-9]{1})([0-9]{13})([0-9]{1})$/,
            tracking_number
          ) ->
        [_full, _application_identifier, _scnc, _, _gsn, _, serial_number, check_string] = match
        check_digit = String.to_integer(check_string)

        ShppdTrack.Checksum.valid_sum_product_with_weightings_and_modulo?(
          serial_number,
          check_digit,
          modulo1: 11,
          modulo2: 10,
          weightings: [1, 7, 3, 1, 7, 3, 1, 7, 3, 1, 7, 3, 1]
        )

      true ->
        false
    end
  end

  @doc """
  Returns a human friendly URL for tracking the package.
  """
  @impl ShppdTrack.Service
  def tracking_url(tracking_number) do
    "https://www.fedex.com/fedextrack/?trknbr=#{tracking_number}"
  end

  @doc """
  Returns tracking information for the package.
  """
  @impl ShppdTrack.Service
  def get_tracking_info(tracking_number) do
    load_fn = fn page ->
      Wallaby.Browser.has_text?(page, tracking_number)
      Wallaby.Browser.has_text?(page, "DELIVERY STATUS")
    end

    with {:ok, response} <- tracking_number |> tracking_url() |> Http.get(load_fn),
         {:ok, html} <- Floki.parse_document(response) do
      status = Floki.find(html, "trk-shared-shipment-delivery-status") |> Floki.text(deep: true)
      {:ok, status}
    end
  end
end
