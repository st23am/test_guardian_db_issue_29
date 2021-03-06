# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :test_guardian_db_error,
  ecto_repos: [TestGuardianDbError.Repo]

# Configures the endpoint
config :test_guardian_db_error, TestGuardianDbError.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZBVS+Gp1f6sF9QCZ5S1Iv7HP0u5KjVxQo1ihSaAkbY1HCd432BYYMA+fg09yx00f",
  render_errors: [view: TestGuardianDbError.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestGuardianDbError.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :guardian_db, GuardianDb,
  repo: TestGuardianDbError.Repo,
  sweep_interval: 120

config :guardian, Guardian,
  hooks: GuardianDb,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "TestGuardianDbError",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "VFiw/mgDqTSDgP19Fj2sD3GTftTD9EE3bO15vscEaPXCb6wzYOQCv3Z2gaI00Gfr",
  serializer: TestGuardianDbError.GuardianSerializer

import_config "#{Mix.env}.exs"
