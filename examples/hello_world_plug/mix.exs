defmodule HelloWorldPlug.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_world_plug,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy, :plug],
     mod: {HelloWorldPlug, []}]
  end

  defp deps do
    [{:plug, "~> 0.8.1"},
     {:cowboy, "~> 1.0.0"}]
  end
end
