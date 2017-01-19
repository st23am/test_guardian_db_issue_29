# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TestGuardianDbError.Repo.insert!(%TestGuardianDbError.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TestGuardianDbError.{Repo, User}
require Logger

test_user = %User{}
|> User.changeset(%{email: "user@example.com", password: "password"})
|> Repo.insert

case test_user do
  {:ok, user} -> {:ok, user}
  {:error, %{errors: [email: {"has already been taken", _}] }} ->
    Logger.info("Test User already exists")
end

