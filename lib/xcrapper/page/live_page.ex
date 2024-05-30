defmodule Xcrapper.Page.LivePage do
  @moduledoc """
  LivePage schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Xcrapper.Page.LivePageLink

  schema "pages" do
    field :title, :string
    field :url, :string
    field :links, :integer

    has_many :page_links, LivePageLink

    timestamps()
  end

  @doc false
  def changeset(live_page, attrs) do
    live_page
    |> cast(attrs, [:title, :url, :links])
    |> validate_required([:url])
    |> cast_assoc(:page_links)
  end
end
