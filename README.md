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
Erlang/OTP 18 [erts-7.3.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

21:25:41.428 [info] Running TestGuardianDbError.Endpoint with Cowboy using http://localhost:4000
21:25:41.429 [info] Application test_guardian_db_error exited: TestGuardianDbError.start(:normal, []) returned an error: shutdown: failed to start child: GuardianDb.ExpiredSweeper
    ** (EXIT) an exception was raised:
        ** (UndefinedFunctionError) function GuardianDb.ExpiredSweeper.start_link/0 is undefined (module GuardianDb.ExpiredSweeper is not available)
            GuardianDb.ExpiredSweeper.start_link()
            (stdlib) supervisor.erl:358: :supervisor.do_start_child/2
            (stdlib) supervisor.erl:341: :supervisor.start_children/3
            (stdlib) supervisor.erl:307: :supervisor.init_children/2
            (stdlib) gen_server.erl:328: :gen_server.init_it/6
            (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
{"Kernel pid terminated",application_controller,"{application_start_failure,test_guardian_db_error,{{shutdown,{failed_to_start_child,'Elixir.GuardianDb.ExpiredSweeper',{'EXIT',{undef,[{'Elixir.GuardianDb.ExpiredSweeper',start_link,[],[]},{supervisor,do_start_child,2,[{file,\"supervisor.erl\"},{line,358}]},{supervisor,start_children,3,[{file,\"supervisor.erl\"},{line,341}]},{supervisor,init_children,2,[{file,\"supervisor.erl\"},{line,307}]},{gen_server,init_it,6,[{file,\"gen_server.erl\"},{line,328}]},{proc_lib,init_p_do_apply,3,[{file,\"proc_lib.erl\"},{line,240}]}]}}}},{'Elixir.TestGuardianDbError',start,[normal,[]]}}}"}

Crash dump is being written to: erl_crash.dump...done
Kernel pid terminated (application_controller) ({application_start_failure,test_guardian_db_error,{{shutdown,{failed_to_start_child,'Elixir.GuardianDb.ExpiredSweeper',{'EXIT',{undef,[{'Elixir.Guardi
```

