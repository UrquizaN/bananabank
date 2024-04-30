defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @required_fields_with_password [:name, :email, :password, :cep]
  @required_fields [:name, :email, :cep]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :cep, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields_with_password)
    |> do_validations(@required_fields_with_password)
    |> add_password_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_fields_with_password)
    |> do_validations(@required_fields)
    |> add_password_hash()
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp add_password_hash(changeset), do: changeset

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> unique_constraint(:email, message: "Email already taken!")
    |> validate_format(:email, ~r/@/, message: "Invalid email format!")
    |> validate_length(:name, min: 3)
    |> validate_length(:cep, is: 8)
  end
end
