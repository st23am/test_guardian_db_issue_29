defmodule TestGuardianDbError.User do
  use TestGuardianDbError.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields [
    :email,
    :password
  ]

  @optional_fields []

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

  def find_and_confirm_password(%{"email" => email, "password" => password}) do
    case TestGuardianDbError.Repo.get_by(TestGuardianDbError.User, email: email) do
      nil -> {:error, ""}
      user ->
        {confirm_password(Comeonin.Bcrypt.checkpw(password, Map.get(user, :password_hash))), user}
    end
  end
  defp confirm_password(true), do: :ok
  defp confirm_password(false), do: :error
end
