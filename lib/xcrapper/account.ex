defmodule Xcrapper.Account do
  @moduledoc """
  This module provides functions for authorizing requests.
  """
  alias Xcrapper.Account.Token

  def login!(user_id) do
    Token.generate_and_sign!(%{user_id: user_id})
  end

  def decode(token) do
    Token.verify_and_validate(token)
  end
end
