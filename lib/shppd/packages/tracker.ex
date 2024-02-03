defmodule Shppd.Packages.Tracker do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "trackers" do
    field :value, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tracker, attrs) do
    tracker
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
