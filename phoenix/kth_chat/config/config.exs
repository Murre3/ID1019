# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kth_chat,
  ecto_repos: [KthChat.Repo]

# Configures the endpoint
config :kth_chat, KthChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ti3BMW4SXlRFBvC/xLkRt1heLbXQcGREu+uv6jQikmg311eADFnWl+OT3P/BlT/T",
  render_errors: [view: KthChatWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KthChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
