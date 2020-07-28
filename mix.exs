defmodule Fetcher.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :url_fetcher,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "UrlFetcher",
      description: "Fetches link and image URLs from web pages",
      source_url: "https://github.com/gorkaio/url_fetcher",
      homepage_url: "https://github.com/gorkaio/url_fetcher",
      docs: [
        # The main page in the docs
        main: "UrlFetcher",
        extras: ["README.md"]
      ],

      # Dialyzer
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_deps: :transitive
      ],
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {UrlFetcher.Application, [env: Mix.env()]},
      applications: applications(Mix.env())
    ]
  end

  defp applications(:test), do: applications(:default) ++ [:cowboy, :plug]
  defp applications(_), do: [:httpoison]

  defp package() do
    [
      name: "url_fetcher",
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/gorkaio/url_fetcher"}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.27.0"}
    ]
  end
end
