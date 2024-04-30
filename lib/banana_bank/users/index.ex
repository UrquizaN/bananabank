defmodule BananaBank.Users.Index do
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call() do
    {:ok, Repo.all(User)}
  end
end
