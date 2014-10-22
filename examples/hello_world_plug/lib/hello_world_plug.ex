defmodule HelloWorldPlug do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(__MODULE__, [], function: :run)
    ]

    opts = [strategy: :one_for_one, name: HelloWorldPlug.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    opts = [port: 8080]
    Plug.Adapters.Cowboy.http HelloWorldPlug.Router, [], opts
  end
end
