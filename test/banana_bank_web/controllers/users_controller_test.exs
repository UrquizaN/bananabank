defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users
  alias Users.User

  import Mox

  setup do
    params = %{"name" => "Jhon", "email" => "jhon@email.com", "password" => "123456", "cep" => "40140650"}

    body = %{
      "bairro" => "Barra",
      "cep" => "40140-650",
      "complemento" => "",
      "ddd" => "71",
      "gia" => "",
      "ibge" => "2927408",
      "localidade" => "Salvador",
      "logradouro" => "Largo do Farol da Barra",
      "siafi" => "3849",
      "uf" => "BA"
    }

    {:ok, body: body, user_params: params}
  end

  describe "index" do
    test "renders users", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "40140650" ->
        {:ok, body}
      end)

      Users.create(params)

      expect(BananaBank.ViaCep.ClientMock, :call, fn "40140650" ->
        {:ok, body}
      end)

      Users.create(%{"name" => "Jhon 2", "email" => "jhon2@email.com", "password" => "123456", "cep" => "40140650"})

      response =
        conn
        |> get(~p"/api/users")
        |> json_response(:ok)

      assert %{
               "data" => [
                 %{"cep" => "40140650", "email" => "jhon@email.com", "id" => _, "name" => "Jhon"},
                 %{"cep" => "40140650", "email" => "jhon2@email.com", "id" => _, "name" => "Jhon 2"}
               ]
             } = response
    end

    test "renders empty users map", %{conn: conn} do
      response =
        conn
        |> get(~p"/api/users")
        |> json_response(:ok)

      assert %{"data" => []} = response
    end
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "40140650" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "40140650", "email" => "jhon@email.com", "id" => _id, "name" => "Jhon"},
               "message" => "User created successfully"
             } = response
    end

    test "returns an error when params are invalid", %{conn: conn} do
      params = %{name: nil, email: "jhon@email.com", password: "123456", cep: "123456"}

      expect(BananaBank.ViaCep.ClientMock, :call, fn "123456" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}}

      assert response == expected_response
    end
  end

  describe "delete/1" do
    test "successfully deletes an user", %{conn: conn, user_params: params, body: body} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "40140650" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      assert %{
               "data" => %{"cep" => "40140650", "email" => "jhon@email.com", "id" => _id, "name" => "Jhon"},
               "message" => "User deleted successfully"
             } = response
    end

    test "returns an error when the user id is invalid", %{conn: conn} do
      response =
        conn
        |> delete(~p"/api/users/99")
        |> json_response(:not_found)

      expected_response = %{"message" => "Resource not found"}

      assert response == expected_response
    end
  end
end
