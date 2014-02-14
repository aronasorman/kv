defmodule Kv.Mixfile do
  use Mix.Project

  def project do
    [ app: :kv,
      version: "0.0.1",
      elixir: "~> 0.12.2",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Kv, [] },
     registered: [:kvserver, :frontend]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
     {:cowboy, github: "extend/cowboy", tag: "0.9.0"}
    ]
  end
end
