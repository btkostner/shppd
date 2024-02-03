defmodule ShppdWeb.Components do
  @moduledoc """
  A collection of components delegated to individual component
  modules. This makes it easy to import all of the common components
  at once.

  ## Examples

  This file is included in the ShppdWeb `html_helpers` macro, so in most
  instances this can be used like so:

      <Components.model />

  """

  defdelegate modal(assigns), to: ShppdWeb.CoreComponents
  defdelegate flash(assigns), to: ShppdWeb.CoreComponents
  defdelegate flash_group(assigns), to: ShppdWeb.CoreComponents
  defdelegate simple_form(assigns), to: ShppdWeb.CoreComponents
  defdelegate button(assigns), to: ShppdWeb.CoreComponents
  defdelegate input(assigns), to: ShppdWeb.CoreComponents
  defdelegate label(assigns), to: ShppdWeb.CoreComponents
  defdelegate error(assigns), to: ShppdWeb.CoreComponents
  defdelegate header(assigns), to: ShppdWeb.CoreComponents
  defdelegate table(assigns), to: ShppdWeb.CoreComponents
  defdelegate list(assigns), to: ShppdWeb.CoreComponents
  defdelegate back(assigns), to: ShppdWeb.CoreComponents
  defdelegate icon(assigns), to: ShppdWeb.CoreComponents
end
