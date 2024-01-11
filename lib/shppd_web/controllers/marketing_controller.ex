defmodule ShppdWeb.MarketingController do
  use ShppdWeb, :controller

  plug :put_layout, html: {ShppdWeb.Layouts, :marketing}

  def homepage(conn, _params) do
    render(conn, :homepage)
  end
end
