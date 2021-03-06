# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :reversi_server,
  ecto_repos: [ReversiServer.Repo]

# Configures the endpoint
config :reversi_server, ReversiServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PwtBtOvDCelQqQ0zHFskxwiWwDPgdtx05ZHth2SI55Q4STj4t6SbA52U1wb9yqVt",
  render_errors: [view: ReversiServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReversiServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :reversi_server,
  id_length: 8,       # Number of bytes for generic unique id
  id_words: 2,        # Number of words used in game ids "ahoy-matey"
  id_number_max: 9999 # Maximal number >= 100 after the words "ahoey-matey-9999".

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
