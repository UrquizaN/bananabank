import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :banana_bank, BananaBank.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "banana_bank_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2,
  port: 5433

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :banana_bank, BananaBankWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+9o3ZfbvjLhPTQk/mh1nHoKHfgTW2E7P1eh/XG4YMNWKnRhD91qC0UCCIQnEGXCg",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
