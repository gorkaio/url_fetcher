defmodule Fetcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :fetcher,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Fetcher",
      source_url: "https://github.com/gorkaio/fetcher",
      homepage_url: "https://github.com/gorkaio/fetcher",
      docs: [
        # The main page in the docs
        main: "Fetcher",
        extras: ["README.md"]
      ],

      # Dialyzer
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:mox, "~> 0.5", only: :test},
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.27.0"}
    ]
  end
end
