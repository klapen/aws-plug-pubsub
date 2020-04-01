defmodule AwsPubsub.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      AwsPubsub.Consumer
    ]

    opts = [strategy: :one_for_one, name: AwsPubsub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
