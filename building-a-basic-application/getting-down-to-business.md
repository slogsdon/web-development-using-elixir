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

