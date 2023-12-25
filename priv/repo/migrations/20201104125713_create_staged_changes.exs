defmodule ExVenture.Repo.Migrations.CreateStagedChanges do
  use Ecto.Migration

  def change do
    create table(:room_staged_changes, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:struct_id, references(:rooms), null: false)

      add(:attribute, :string, null: false)
      add(:value, :binary, null: true)

      timestamps()
    end

    create index(:room_staged_changes, [:struct_id, :attribute], unique: true)

    create table(:zone_staged_changes, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:struct_id, references(:zones), null: false)

      add(:attribute, :string, null: false)
      add(:value, :binary, null: true)

      timestamps()
    end

    create index(:zone_staged_changes, [:struct_id, :attribute], unique: true)
  end
end
