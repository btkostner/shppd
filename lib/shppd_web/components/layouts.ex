defmodule ShppdWeb.Layouts do
  use ShppdWeb, :html

  defp current_year(), do: DateTime.utc_now().year

  embed_templates "layouts/*"
end
