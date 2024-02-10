defmodule ShppdTrack.Service.FedEx do
  @moduledoc """
  Tracking packages in the FedEx system.
  """

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
  Returns tracking information for the package. This works by
  starting a new chromedriver browser and navigating to the
  FedEx tracking page. It then waits for the page to load. Once
  the page is loaded, it will find the backend API network call
  and extract the JSON response. This is to bypass requiring
  setting up a developer account.
  """
  @impl ShppdTrack.Service
  def get_tracking_info(tracking_number) do
    with {:ok, authentication} <- fedex_authentication(),
         {:ok, _response} <- fedex_request(tracking_number, authentication) do
      {:ok, %ShppdTrack.Info{}}
    end
  end

  defp fedex_request(tracking_number, authentication) do
    config = Application.get_env(:shppd, __MODULE__)

    host =
      if Keyword.get(config, :production_environment?),
        do: "https://apis.fedex.com/track/v1/trackingnumbers",
        else: "https://apis-sandbox.fedex.com/track/v1/trackingnumbers"

    request =
      Req.new(
        body:
          Jason.encode!(%{
            trackingInfo: [
              %{
                trackingNumberInfo: %{
                  trackingNumber: tracking_number
                }
              }
            ],
            includeDetailedScans: true
          }),
        headers: [
          {"Content-Type", "application/json"},
          {"Authorization", "Bearer #{authentication}"},
          {"x-locale", "en_US"}
        ],
        method: :get,
        url: host
      )

    with {:ok, response} <- Req.get(request) do
      IO.inspect(response, label: "response")

      if response.status != 200 do
        {:error, hd(response.body["errors"])["message"]}
      else
        {:ok, response.body}
      end
    end
  end

  @spec fedex_authentication() :: {:ok, String.t()} | {:error, term()}
  defp fedex_authentication() do
    config = Application.get_env(:shppd, __MODULE__)

    host =
      if Keyword.get(config, :production_environment?),
        do: "https://apis.fedex.com/oauth/token",
        else: "https://apis-sandbox.fedex.com/oauth/token"

    request =
      Req.new(
        body:
          URI.encode_query(
            grant_type: "client_credentials",
            client_id: Keyword.get(config, :api_key),
            client_secret: Keyword.get(config, :api_secret)
          ),
        headers: [
          {"Content-Type", "application/x-www-form-urlencoded"}
        ],
        method: :post,
        url: host
      )

    with {:ok, response} <- Req.post(request) do
      {:ok, response.body["access_token"]}
    end
  end
end
