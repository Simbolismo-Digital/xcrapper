defmodule Xcrapper.Page.LivePage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :title, :string
    field :url, :string
    field :links, :integer

    timestamps()
  end

  @doc false
  def changeset(live_page, attrs) do
    live_page
    |> cast(attrs, [:title, :url, :links])
    |> validate_required([:url])
  end
end
