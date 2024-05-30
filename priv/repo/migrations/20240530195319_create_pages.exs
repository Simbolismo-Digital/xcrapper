defmodule Xcrapper.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :url, :string
      add :links, :integer

      timestamps()
    end
  end
end
