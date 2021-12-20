import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :morphydb_web, MorphyDBWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zU+AI/ossBHKCwDgMk7H9vc+tqqQVGrO8NZcZS1EJqh6SpK2gvaXnHyyXmSM+r3w",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :morphydb, MorphyDB.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
