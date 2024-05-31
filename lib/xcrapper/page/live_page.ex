defmodule Xcrapper.Page.LivePage do
  @moduledoc """
  LivePage schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Xcrapper.Page.LivePageLink
  alias Xcrapper.User

  schema "pages" do
    field :title, :string
    field :url, :string
    field :links, :integer

    belongs_to :user, User
    has_many :page_links, LivePageLink

    timestamps()
  end

  @doc false
  def changeset(live_page, attrs) do
    Xcrapper.Repo.all(Xcrapper.User)

    live_page
    |> cast(attrs, [:title, :url, :links, :user_id])
    |> validate_required([:url, :user_id])
    |> cast_assoc(:page_links)
  end
end
