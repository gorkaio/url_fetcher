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
        main: "Fetcher", # The main page in the docs
        extras: ["README.md"]
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
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
