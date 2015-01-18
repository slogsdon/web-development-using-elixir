defmodule CompanyXyz.Web.Mixfile do
  use Mix.Project

  def project do
    [app: :web,
     version: "0.0.1",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy, :plug],
     mod: {CompanyXyz.Web, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 0.9.0"}]
  end
end
