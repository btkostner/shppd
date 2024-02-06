# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :shppd,
  ecto_repos: [Shppd.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :shppd, ShppdWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ShppdWeb.ErrorHTML, json: ShppdWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Shppd.PubSub,
  live_view: [signing_salt: "1joTv5Sx"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :shppd, Shppd.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(scripts/main.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.1",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=styles/main.css
      --output=../priv/static/assets/main.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :wallaby, :hackney_options,
  recv_timeout: 30_000,
  timeout: 30_000

config :wallaby, :chromedriver,
  capabilities: %{
    javascriptEnabled: true,
    loadImages: true,
    rotatable: false,
    takesScreenshot: false,
    cssSelectorsEnabled: true,
    nativeEvents: true,
    unhandledPromptBehavior: "accept",
    chromeOptions: %{
      args: [
        "--incognito",
        "--no-sandbox",
        "--window-size=1423,974",
        "--disable-web-security",
        "--disable-site-isolation-trials",
        "--disable-blink-features=AutomationControlled",
        "--headless",
        "--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
      ],
      useAutomationExtension: False
    }
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
