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

