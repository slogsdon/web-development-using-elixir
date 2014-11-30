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

Follow along in your own environment, or pull down the project from the [`HelloWorld`](https://github.com/slogsdon/web-development-using-elixir/tree/master/examples/hello_world) project page.

# Mixing It Up

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

`project/0` provides your project's configuration (in keyword list form) to Mix.`app: :hello_world` sets our application's name in Erlang/OTP land.

`version: "0.0.1"` sets our application's version, and `elixir: "~> 1.0.0"` sets the version of Elixir on which our application depends. All versions in the Elixir world typically follow [semantic versioning](http://semver.org/), so keep that in mind when you're dealing with them.

`deps: deps` sets our project's dependencies with the `deps/0` function, which is currently an empty list. Using the [Hex Package manager](https://hex.pm/), dependencies are added as two-item tuples like `{:dependency, "~> 1.0.0"}`.

`application/0` provides your project's OTP application configuration (in keyword list form) to Mix. `applications: [:logger]` lists the OTP applications on which your project depends. These applications will be started for you automatically when your application runs.

`mod: {HelloWorld, []}` provides details for OTP to run your application. With Mix building your project's skeleton, you shouldn't need to change this, but the first element in the tuple is the module that contains the `start/2` callback function for the `Application` behaviour, which in our case is `HelloWorld`. If you ever rename your project and/or rename/refactor your modules, be sure to update this line to reflect any changes.

# Getting Down to Business

Now for us to get a web application running, we'll need a server that can speak HTTP, so it's time for you to build a `HTTP/1.1` compliant server. You have fun with that. I'll wait.

Don't want to do that just to write a "Hello World" app? I don't blame you, so instead of writing our own, let's use [Cowboy](https://github.com/ninenines/cowboy), a very popular Erlang web server. First thing's first. Let's add Cowboy as a dependency in our `mix.exs` file:

```elixir
  defp deps do
    [{:cowboy, "~> 1.0.0"}]
  end
```

and to prepare a bit for the future, we need to add `:cowboy` under `applications` in `application/0`:

```elixir
  def application do
    [applications: [:logger, :cowboy],
     mod: {HelloWorld, []}]
  end
```

Now, let's pull down our deps from Hex:

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

Thanks to the power of Hex and S3, that shouldn't have taken long. We're now able to implement Cowboy into our project to leverage all of the goodness it provides.

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

# Running Our Marvelous Work

Now's the time for our hard work to pay off. Pass mix as a script to IEx with `iex -S mix`:

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

If you didn't add `HelloWorld.run/0` as a worker child in the supervisor tree, be sure to run that in the IEx console.

```
iex(1)> HelloWorld.run
{:ok, #PID<0.141.0>}
iex(2)>
```

From here, you should be able to open a browser and point it to `http://localhost:8080/` to see the "Hello world!" message presented to us from our handler.

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

Check that out. Way to go! You now have the knowledge to create a basic web application, but I bet you're saying something like, "There has to be something more."

You're right.