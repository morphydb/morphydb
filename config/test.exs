import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :morphy_db, MorphyDbWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+qL1KLpo67ifTEry1L+c+kdnL9JK/wNxAu5c7PYthb2sCAQmCfRucPd3apafN2Uq",
  server: false

# In test we don't send emails.
config :morphy_db, MorphyDb.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
