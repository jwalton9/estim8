import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :estim8, Estim8Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "82kNDS1fWhscU4FLi5/UM2zqqfNR23lpSNG1RlVPEe0bt/n7forLR4cpOHtx9Z7g",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
