defmodule ShppdTrack.Http do
  @moduledoc """
  Simple HTTP client for grabbing information from
  the world wide web.
  """

  require Wallaby.Browser

  @doc """
  Standard HTTP GET request to a website. This will spin
  up an actual Chrome browser to fully scrape a page with
  JavaScript enabled. It returns the full HTML document as
  a string.

  ## Options

    - `load_fn` - A function that takes a Wallaby browser page
      and ensures that the page has loaded the content you
      need. This is helpful for websites that require special
      waits for JS to load.

  """
  @spec get(binary()) :: {:ok, binary()} | {:error, term()}
  def get(url, load_fn \\ fn page -> page end) do
    with {:ok, browser} <- Wallaby.start_session() do
      {:ok, do_get(browser, url, load_fn)}
    end
  end

  defp do_get(browser, url, load_fn) do
    browser
    # Remove obvious signs of automation
    |> Wallaby.Browser.execute_script(
      "Object.defineProperty(navigator, 'webdriver', {get: () => undefined})"
    )
    |> Wallaby.Browser.visit(url)
    |> tap(load_fn)
    |> tap(fn _ ->
      # Wait a random amount of time because we are 100% not a bot
      1000..5000
      |> Enum.random()
      |> Process.sleep()
    end)
    |> Wallaby.Browser.find(Wallaby.Query.css("html"))
    |> Wallaby.Element.attr("outerHTML")
  after
    Wallaby.stop(browser)
  end
end
