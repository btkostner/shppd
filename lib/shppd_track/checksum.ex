defmodule ShppdTrack.Checksum do
  @moduledoc """
  Checksum utility functions for validating tracking numbers.
  """

  import Integer, only: [is_even: 1]

  def valid_mod10?(sequence, check_digit, opts \\ []) do
    sum =
      sequence
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(0, fn {c, i}, total ->
        total +
          if is_even(i),
            do: c * Keyword.get(opts, :evens_multiplier, 0),
            else: c * Keyword.get(opts, :odds_multiplier, 0)
      end)

    sum = rem(sum, 10)

    sum =
      if sum != 0,
        do: 10 - sum,
        else: sum

    sum == check_digit
  end

  def valid_sum_product_with_weightings_and_modulo?(sequence, check_digit, opts \\ []) do
    modulo1 = Keyword.fetch!(opts, :modulo1)
    modulo2 = Keyword.fetch!(opts, :modulo2)
    weighting = Keyword.get(opts, :weightings, [])

    sum =
      sequence
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.zip(weighting)
      |> Enum.reduce(0, fn {a, b}, total ->
        total + a * b
      end)

    rem(rem(sum, modulo1), modulo2) == check_digit
  end
end
