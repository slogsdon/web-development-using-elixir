# Building a Basic Application

Starting with any project in a new-to-you language, a big question is usually, "Where do I put my files?" Well, fret not! We'll use Mix to generate a project skeleton for us.

> Mix is a build tool that provides tasks for creating, compiling, testing Elixir projects, as well as handle dependencies, and more.

Let's create our project with `mix new`:

```
$ mix new hello_world --sup
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/hello_world.ex
* creating test
* creating test/test_helper.exs
* creating test/hello_world_test.exs

Your mix project was created successfully.
You can use mix to compile it, test it, and more:

    cd hello_world
    mix test

Run `mix help` for more commands.

$ cd hello_world
```

We passed two arguments to the `mix new` task: a project name in snake case (`hello_world`) and the `--sup` flag. Mix used the project name as our OTP application name and converted it to camel case (`HelloWorld`) for use in module names when creating our project. The `--sup` flag let Mix know that we wanted it to create an OTP supervisor and an OTP application callback in our main `HelloWorld` module.

## Mixing It Up

Moving on into the future, Mix will help us with our dependencies, testing our app, running our app, and more, but how does Mix know enough about our project to help us so much? Our Mixfile, of course! Let's open our `mix.exs` to take a look:

```elixir
defmodule HelloWorld.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_world,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {HelloWorld, []}]
  end

  defp deps do
    []
  end
end
```

Two key things to look at are `project/0` and `application/0` (the `project` and `application` functions).

`HelloWorld.Mixfile.project/0`

`HelloWorld.Mixfile.application/0`

Add Cowboy as a dependency:

```elixir
  defp deps do
    [{:cowboy, "~> 1.0.0"}]
  end
```

Get deps from Hex:

```
$ mix deps.get
Running dependency resolution
Unlocked:   cowboy
Dependency resolution completed successfully
  cowlib: v1.0.0
  cowboy: v1.0.0
  ranch: v1.0.0
* Getting cowboy (package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/cowboy-1.0.0.tar)
Using locally cached package
Unpacked package tarball (/Users/shane/.hex/packages/cowboy-1.0.0.tar)
* Getting cowlib (package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/cowlib-1.0.0.tar)
Using locally cached package
Unpacked package tarball (/Users/shane/.hex/packages/cowlib-1.0.0.tar)
* Getting ranch (package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/ranch-1.0.0.tar)
Using locally cached package
Unpacked package tarball (/Users/shane/.hex/packages/ranch-1.0.0.tar)
```

Supervisor additions:

```elixir
  def run do
    routes = [
      {"/", HelloWorld.Handler, []}
    ]
    dispatch = :cowboy_router.compile([{:_, routes}])
    opts = [port: 8080]
    env = [dispatch: dispatch]
    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
  end
```

and a worker child for our supervisor tree.

Resulting in:

```elixir
defmodule HelloWorld do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
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

Handler:

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

Run:

```
$ iex -S mix
Erlang/OTP 17 [erts-6.2] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

==> ranch (compile)
Compiled src/ranch_transport.erl
Compiled src/ranch_sup.erl
Compiled src/ranch_ssl.erl
Compiled src/ranch_tcp.erl
Compiled src/ranch_protocol.erl
Compiled src/ranch_listener_sup.erl
Compiled src/ranch_app.erl
Compiled src/ranch_acceptors_sup.erl
Compiled src/ranch_acceptor.erl
Compiled src/ranch.erl
Compiled src/ranch_server.erl
Compiled src/ranch_conns_sup.erl
==> cowlib (compile)
Compiled src/cow_qs.erl
Compiled src/cow_spdy.erl
Compiled src/cow_multipart.erl
Compiled src/cow_http_te.erl
Compiled src/cow_http_hd.erl
Compiled src/cow_date.erl
Compiled src/cow_http.erl
Compiled src/cow_cookie.erl
Compiled src/cow_mimetypes.erl
==> cowboy (compile)
Compiled src/cowboy_sub_protocol.erl
Compiled src/cowboy_middleware.erl
Compiled src/cowboy_websocket_handler.erl
Compiled src/cowboy_sup.erl
Compiled src/cowboy_static.erl
Compiled src/cowboy_spdy.erl
Compiled src/cowboy_router.erl
Compiled src/cowboy_websocket.erl
Compiled src/cowboy_rest.erl
Compiled src/cowboy_loop_handler.erl
Compiled src/cowboy_protocol.erl
Compiled src/cowboy_http_handler.erl
Compiled src/cowboy_handler.erl
Compiled src/cowboy_clock.erl
Compiled src/cowboy_bstr.erl
Compiled src/cowboy_app.erl
Compiled src/cowboy.erl
Compiled src/cowboy_http.erl
Compiled src/cowboy_req.erl
Compiled lib/hello_world/handler.ex
Compiled lib/hello_world.ex
Generated hello_world.app
Interactive Elixir (1.0.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Test:

```
$ curl -i http://localhost:8080
HTTP/1.1 200 OK
connection: keep-alive
server: Cowboy
date: Tue, 14 Oct 2014 00:52:09 GMT
content-length: 12
content-type: text/plain

Hello world!
```

[`HelloWorld`](https://github.com/slogsdon/web-development-using-elixir/tree/master/examples/hello_world) project page