defmodule Xcrapper.Repo.Migrations.AddPagesUserId do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:pages, [:user_id])
  end
end
