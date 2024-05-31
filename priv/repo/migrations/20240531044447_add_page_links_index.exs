defmodule Xcrapper.Repo.Migrations.AddPageLinksIndex do
  use Ecto.Migration

  def change do
    create index(:page_links, [:live_page_id])
  end
end
