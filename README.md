# TestGuardianDbError

I was experiencing the issue:
* https://github.com/ueberauth/guardian_db/issues/29

So I created this repo to test it.

I was able to resolve it by adding `:guardian_db` and `:distillery` to my applications list in `mix.exs`

You can run this application and see it working by opening a terminal and running the following commands.

1. `mix deps.get`

2. `MIX_ENV=prod mix ecto.create`

3. `MIX_ENV=prod mix ecto.migrate`

4. `MIX_ENV=prod mix run priv/repo/seeds.exs`

5. `npm install`

6. `MIX_ENV=prod mix phoenix.digest`

7. `MIX_ENV=prod mix release`

8. `_build/prod/rel/test_guardian_db_error/bin/test_guardian_db_error console`

9. Open a your browser to `http://localhost:4000`

## Reproducing the original error

To reproduce the original error follow the above steps and then the steps below.

1. `git checkout broken`

2. `MIX_ENV=prod mix release.clean`

3. `MIX_ENV=prod mix release`

4. `_build/prod/rel/test_guardian_db_error/bin/test_guardian_db_error console`

You should get an error like the orignal error message in the github issue above.

```

```

