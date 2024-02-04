defmodule ShppdTrack.Service.FedExTest do
  use ExUnit.Case

  import ShppdTrack.Service.FedEx

  doctest ShppdTrack.Service.FedEx

  describe "friendly_name/1" do
    test "returns a human friendly name" do
      assert friendly_name("123456789012") == "FedEx"
    end
  end

  describe "valid_tracking_number?/1" do
    test "FedEx Ground" do
      assert valid_tracking_number?("041441760228964")
      assert valid_tracking_number?("568283610012000")
      assert valid_tracking_number?("568283610012734")
      refute valid_tracking_number?("568283610012732")
    end

    test "FedEx Ground (SSCC-18)" do
      assert valid_tracking_number?("000123450000000027")
      refute valid_tracking_number?("000000000000000001")
    end

    test "FedEx Ground 96 (22)" do
      assert valid_tracking_number?("9611020987654312345672")
      refute valid_tracking_number?("9600000000000000000001")
    end

    test "FedEx Ground GSN" do
      assert valid_tracking_number?("9622001900000000000000776632517510")
      assert valid_tracking_number?("9622001560000000000000794808390594")
      assert valid_tracking_number?("9622001560001234567100794808390594")
      assert valid_tracking_number?("9632001560123456789900794808390594")
      refute valid_tracking_number?("9622001560001234567100794808390595")
      refute valid_tracking_number?("9622001560001234567100794808390597")
    end
  end

  describe "tracking_url/1" do
    test "returns user facing tracking url" do
      assert tracking_url("123456789012") ==
               "https://www.fedex.com/fedextrack/?trknbr=123456789012"
    end
  end

  @tag timeout: 200_000
  describe "get_tracking_info/1" do
    test "returns tracking information" do
      assert get_tracking_info("99999999999") == %{}
    end
  end
end
