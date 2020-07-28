defmodule UrlFetcherTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest UrlFetcher
  alias UrlFetcher.SiteData
  alias Plug.Conn.Query

  @base_url "http://localhost:8081/"
  @test_url @base_url <> "test/"
  @redirect_url @base_url <> "redirect/"
  @failure_url @base_url <> "failure/"

  test "Rejects invalid uls" do
    assert {:error, :invalid_url} == UrlFetcher.fetch(5, http_client: UrlFetcher.Http.Adapter.Poison)
  end

  test "Returns empty lists for pages without links or images" do
    expected = {:ok, SiteData.new()}
    actual = UrlFetcher.fetch(@test_url, http_client: UrlFetcher.Http.Adapter.Poison)

    assert expected == actual
  end

  test "Returns lists of assets and links" do
    links = ["https://gorka.io", "https://gorka.io/about"]
    assets = ["https://gorka.io/logo.svg", "https://gorka.io/logo2.png"]
    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    expected = {:ok, SiteData.new() |> SiteData.with_links(links) |> SiteData.with_assets(assets)}
    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison)

    assert expected == actual
  end

  test "Normalizes lists of assets and links to absolute urls" do
    links = ["https://gorka.io", "about", "https://elixirforum.com/t/what-elixir-related-stuff-are-you-doing/113"]

    assets = [
      "logo.svg",
      "https://gorka.io/logo2.png",
      "https://elixirforum.com/uploads/default/original/2X/6/69cdf106f7ad3749056956ca28dc41e6b9b6a145.png"
    ]

    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    expected =
      {:ok,
       SiteData.new()
       |> SiteData.with_links([
         "https://gorka.io",
         @test_url <> "about",
         "https://elixirforum.com/t/what-elixir-related-stuff-are-you-doing/113"
       ])
       |> SiteData.with_assets([
         @test_url <> "logo.svg",
         "https://gorka.io/logo2.png",
         "https://elixirforum.com/uploads/default/original/2X/6/69cdf106f7ad3749056956ca28dc41e6b9b6a145.png"
       ])}

    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison, normalize: :absolute)

    assert expected == actual
  end

  test "Removes duplicates from assets and links" do
    links = ["https://gorka.io", "https://gorka.io/about", "https://gorka.io"]
    assets = ["https://gorka.io/logo.png", "https://gorka.io/logo.png"]
    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    expected = {
      :ok,
      SiteData.new()
      |> SiteData.with_links(["https://gorka.io", "https://gorka.io/about"])
      |> SiteData.with_assets(["https://gorka.io/logo.png"])
    }

    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison)

    assert expected == actual
  end

  test "Duplicate removal is configurable via options" do
    links = ["https://gorka.io", "https://gorka.io/about", "https://gorka.io"]
    assets = ["https://gorka.io/logo.png", "https://gorka.io/logo.png"]
    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    expected = {
      :ok,
      SiteData.new()
      |> SiteData.with_links(links)
      |> SiteData.with_assets(assets)
    }

    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison, unique: false)

    assert expected == actual
  end

  test "Filtering out external links is configurable via options" do
    links = [@base_url, "/about.html", "https://elixir-lang.org/install.html"]
    assets = [@base_url <> "/logo.png", "https://elixir-lang.org/logo.png", "test/logo.jpg"]
    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    expected = {
      :ok,
      SiteData.new()
      |> SiteData.with_links([@base_url, "/about.html"])
      |> SiteData.with_assets([@base_url <> "/logo.png", "test/logo.jpg"])
    }

    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison, internal_only: true)

    assert expected == actual
  end

  test "Follows redirects" do
    links = ["https://gorka.io", "https://gorka.io/about"]
    assets = ["https://gorka.io/logo.svg", "https://gorka.io/logo2.png"]
    params = %{links: links, assets: assets}

    redirect_to =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    url =
      @redirect_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(%{page: redirect_to}))
      |> URI.to_string()

    expected = {:ok, SiteData.new() |> SiteData.with_links(links) |> SiteData.with_assets(assets)}
    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison)

    assert expected == actual
  end

  test "Returns error for failed requests" do
    expected = {:error, 404}

    url =
      @failure_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(%{status: 404}))
      |> URI.to_string()

    actual = UrlFetcher.fetch(url, http_client: UrlFetcher.Http.Adapter.Poison)

    assert expected == actual
  end
end
