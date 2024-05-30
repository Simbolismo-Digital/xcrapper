defmodule Xcrapper.Repo.Migrations.CreatePageLinks do
  use Ecto.Migration

  def change do
    create table(:page_links) do
      add :href, :string
      add :text, :string
      add :live_page_id, references(:pages, on_delete: :delete_all)

      timestamps()
    end
  end
end
