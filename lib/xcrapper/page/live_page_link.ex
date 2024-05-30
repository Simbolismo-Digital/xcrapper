defmodule Xcrapper.Page.LivePageLink do
  @moduledoc """
  LivePageLink schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Xcrapper.Page.LivePage

  schema "page_links" do
    field :href, :string
    field :text, :string

    belongs_to :live_page, LivePage

    timestamps()
  end

  @doc false
  def changeset(live_page, attrs) do
    live_page
    |> cast(attrs, [:href, :text, :live_page_id])
    |> validate_required([:href, :text])
  end
end
