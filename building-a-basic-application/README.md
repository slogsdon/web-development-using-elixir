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
