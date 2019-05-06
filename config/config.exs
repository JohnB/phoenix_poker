# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_poker,
  ecto_repos: [PhoenixPoker.Repo]

# Configures the endpoint
config :phoenix_poker, PhoenixPokerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  #secret_key_base: "65VuAUdt6sAy5qlqJKcLn/x0zE19XLhZMjRdKZ1q5DqmaNZb142aSoPSsDnGmoRc",
  render_errors: [view: PhoenixPokerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixPoker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [default_scope: "user"] },
    google: { Ueberauth.Strategy.Google, [] },
    identity: { Ueberauth.Strategy.Identity, [
        callback_methods: ["POST"],
        uid_field: :username,
        nickname_field: :username,
      ] },
    twitter: { Ueberauth.Strategy.Twitter, []}
  ]
  
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET"),
  redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: System.get_env("SLACK_CLIENT_ID"),
  client_secret: System.get_env("SLACK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")


# See https://us-west-2.console.aws.amazon.com/ses/home?region=us-west-2#smtp-settings:
# For what Amazon Simple Email Service allows.
# See also: https://www.google.com/search?q=standard+SMTP+ports&oq=standard+SMTP+ports&aqs=chrome..69i57j0.6194j0j7&sourceid=chrome&ie=UTF-8
#
#config :phoenix_poker, PhoenixPoker.Mailer,
#  adapter: Bamboo.SMTPAdapter,
#  server: "email-smtp.us-west-2.amazonaws.com",
#  port: 587, # or 25, or 587,
#  username: System.get_env("SMTP_USERNAME"),
#  password: System.get_env("SMTP_PASSWORD"),
#  tls: :always, # can be `:always`, ':if_available' or `:never`
#  ssl: false, # can be `true`
#  retries: 1
  

#config :dogma,
#  rule_set: Dogma.RuleSet.All
