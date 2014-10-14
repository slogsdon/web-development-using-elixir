defmodule HelloWorld.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_world,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy],
     mod: {HelloWorld, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"}]
  end
end
