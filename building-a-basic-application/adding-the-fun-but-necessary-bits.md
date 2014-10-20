# Adding the Fun (but Necessary) Bits

Open up `lib/hello_world.ex` so we can get to work. Most of the work here will entail getting Cowboy set up so that it will listen for incoming requests. Even though we have set up our `mix.exs` file to start the `:cowboy` OTP application, Cowboy doesn't start HTTP or HTTPS listeners by default and relys on developers (us) to do so.

We'll create a helper function that defines a set of routes for our application, compile those routes into a form the Cowboy dispatcher knows how to use, and finally, start the HTTP listener with some basic options.

```elixir
  def run do
    # Routes for our application
    routes = [
      {"/", HelloWorld.Handler, []}
    ]

    # Compile our routes so Cowboy knows
    # how to dispatch requests
    dispatch = :cowboy_router.compile([{:_, routes}])

    # Set some options
    opts = [port: 8080]
    env = [dispatch: dispatch]
    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
  end
```

Optionally, we can add a worker child for our supervisor tree to run this function automatically when our application starts, otherwise, the function will need to be run manually, such as in an IEx session.

Resulting in:

```elixir
defmodule HelloWorld do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Optional worker child for HelloWorld.run/0
      worker(__MODULE__, [], function: :run)
    ]

    opts = [strategy: :one_for_one, name: HelloWorld.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    routes = [
      {"/", HelloWorld.Handler, []}
    ]
    dispatch = :cowboy_router.compile([{:_, routes}])
    opts = [port: 8080]
    env = [dispatch: dispatch]
    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
  end
end
```

When called, `run/0` will allow our application to respond to all requests to `http://localhost:8080/`.

## Handle Yourself Properly

We defined a singular route that has some sort of relation to an undefined `HelloWorld.Handler` module, but what should be in this module? Create `lib/hello_world/handler.ex`, and put this in it:

```elixir
defmodule HelloWorld.Handler do
  def init({:tcp, :http}, req, opts) do
    headers = [{"content-type", "text/plain"}]
    body = "Hello world!"
    {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
    {:ok, resp, opts}
  end

  def handle(req, state) do
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
```

`init/3` handles the bulk of the work here. It let's Cowboy know what types of connections we wish to handle with this module (HTTP via TCP) and actually creates a response for each incoming request. We use `:cowboy_req.reply/4` to build our response with a status code, a list of headers, a response body, and the request itself as Cowboy stashes supporting information about the request in that variable.

`handle/2` and `terminate/3` aren't terribly useful in this example, but in other cases, they offer the means to control the lifespan of the Erlang process that is spawned to handle the request. For now, consider them necessary boilerplate code.

