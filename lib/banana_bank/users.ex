defmodule BananaBank.Users do
  alias BananaBank.Users.Create
  alias BananaBank.Users.Delete
  alias BananaBank.Users.Index
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update

  defdelegate index(), to: Index, as: :call
  defdelegate create(params), to: Create, as: :call
  defdelegate delete(id), to: Delete, as: :call
  defdelegate show(id), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
end
