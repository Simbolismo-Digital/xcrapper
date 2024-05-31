defmodule Xcrapper.User do
  @moduledoc """
  User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Xcrapper.Page.LivePage

  schema "users" do
    field :username, :string
    field :password_hash, :string

    has_many :live_pages, LivePage

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username, :password_hash])
    |> validate_required([:username, :password_hash])
    |> update_change(:username, &clean/1)
    |> unique_constraint(:username)
    |> hash_password()
  end

  def check_password(user, password) do
    Bcrypt.verify_pass(password, user.password_hash)
  end

  defp clean(string) do
    string
    |> String.trim()
    |> String.downcase()
  end

  defp hash_password(%{errors: []} = changeset) do
    encrypted =
      changeset
      |> get_change(:password_hash)
      |> Bcrypt.hash_pwd_salt()

    put_change(changeset, :password_hash, encrypted)
  end

  defp hash_password(changeset), do: changeset
end
