defmodule Estim8Web.Presence do
  use Phoenix.Presence,
    otp_app: :estim8,
    pubsub_server: Estim8.PubSub
end
