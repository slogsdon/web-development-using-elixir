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

