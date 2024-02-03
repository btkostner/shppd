defmodule Shppd.Repo.Migrations.CreateTrackers do
  use Ecto.Migration

  def change do
    create table(:trackers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :string

      timestamps(type: :utc_datetime)
    end
  end
end
