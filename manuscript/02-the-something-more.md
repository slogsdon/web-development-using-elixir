# The Something More

While interoperating with Erlang code can provide many benefits,
the resulting Elixir code can end up very non-idiomatic, and the
necessary bits needed to work with Cowboy directly adds some
bloat to our project which would otherwise be fairly lean.

So what's the something more? Meet [Plug][plug].

## Plug In

What's Plug? Let's see what the project's code repository has to say:

> Plug is:
>
> 1. A specification for composable modules in between web applications
> 2. Connection adapters for different web servers in the Erlang VM

We should deconstruct those statements.

### A Specification

Part of what lets Plug is its [specification][plug-spec], letting
implementors know what is given to and expected from a plug a.k.a. a
composable module. According to the spec, there are two types of
plugs: function and module.

Function plugs are single functions that follow the signature
`(Plug.Conn.t, Plug.opts) :: Plug.Conn.t`. In other words, a function
plug accepts a connection and an optional set of options for the plug
to use, which can be any term that is a tuple, atom, integer, float,
or list of the aforementioned types, and returns a connection.

Module plugs operate similarly, requiring a public function `call/2`
that follows the same signature as a function plug. Module plugs also
require an `info/1` function to be use to preprocess options sent to
it. Often, `call/2` is invoked as `call(conn, info(opts))`, especially
(as we'll see later on) when a plug stack is compiled.

### Connection Adapters

With Erlang being great for scalable network programming, it seems
only natural that people wanted to use it for web programming over
the years since Erlang's release in the mid-1980s. Erlang's standard
installation comes with a long list of modules, including one for
[creating HTTP servers][inets], but the `httpd` module isn't really
made for production-level servers.

Because of that, many people have developed some awesome HTTP servers
over the years, including [Cowboy][cowboy], [Mochiweb][mochiweb],
[Yaws][yaws], [Elli][elli], and [Misultin][misultin]. Wouldn't it be
great if we could change the web server used in our application
based on needs or even on a whim? Well, you're in luck because that
is part of what Plug is trying to achieve with connection adapters.

Currently, Plug only (officially) [supports Cowboy][cowboy-adapter],
but there is an [open PR][elli-adapter-pr] for adding an adapter for
Elli, with others probably hidden around the internets. If you ever
wanted to use an Erlang or Elixir web server with Plug that isn't
supported, all you would need to do is make sure you implemented
the [`Plug.Conn.Adapter` behaviour][plug-adapter-behaviour].
Simple, huh?

Ok, enough with the yammering. Let's get back into some code.

## Route to Your Heart

One benefit with using Plug is `Plug.Router`, a routing DSL with
some visual similarities to [Sinatra][sinatra]. It really takes the
pain away from compiling a dispatch list using the raw, Erlang term
based format that Cowboy expects.

```elixir
defmodule HelloWorldPlug.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
  end
end
```

See? Isn't that better? `Plug.Router` has macros for handling `GET`,
`POST`, `PUT`, `PATCH`, `DELETE`, and `OPTIONS` requests, with a
general `match` macro that can be used to handle other HTTP methods
you may require for your application.

## Connecting Connections

Looking back at the previous code snippet (the route), you may have
some questions. *What's that `conn` thing?* *Why aren't we doing
anything with it?* *Why do we just return it?* These would be
perfectly good things to ask considering we basically glanced over
the code quickly before.

Essentially, the code let's us know that we expect our application
to handle `GET` requests to `/` (the root). The `get` macro we use
injects a `conn` variable into the local with some macro magic (we
will learn a little about this later), and because, for the moment,
we're lazy and don't know any better, we let the `conn` pass
through unmodified as our return expression.

Wait. What's that? You don't want to be lazy anymore and want to
send a message to your applications visitors? Let's say hi!

```elixir
  get "/" do
    conn
      |> Plug.Conn.send_resp(200, "Hello world!")
  end
```

Here, we use `send_resp/3` from the `Plug.Conn` module to send a
`200 OK` response with our message. `Plug.Conn` has a variety of
functions for reading from and creating new `conn`s. We will touch
on a lot of these as we progress, but if you're interested now,
take a look to see [what it has to offer][plug-conn].

[plug]: https://github.com/elixir-lang/plug
[plug-spec]: https://github.com/elixir-lang/plug/blob/master/lib/plug.ex#L3-L21
[plug-adapter-behaviour]: https://github.com/elixir-lang/plug/blob/master/lib/plug/conn/adapter.ex#L8
[plug-conn]: https://github.com/elixir-lang/plug/blob/master/lib/plug/conn.ex

[cowboy]: https://github.com/ninenines/cowboy
[cowboy-adapter]: https://github.com/elixir-lang/plug/blob/master/lib/plug/adapters/cowboy.ex
[mochiweb]: https://github.com/mochi/mochiweb
[misultin]: https://github.com/ostinelli/misultin
[elli]: https://github.com/knutin/elli
[elli-adapter-pr]: https://github.com/elixir-lang/plug/pull/11
[yaws]: https://github.com/klacke/yaws
[inets]: http://www.erlang.org/doc/man/httpd.html

[sinatra]: http://www.sinatrarb.com/intro.html
