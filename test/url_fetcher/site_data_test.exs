defmodule UrlFetcher.SiteDataTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias UrlFetcher.SiteData
  doctest SiteData

  test "Creates new site data" do
    assert SiteData.new() == %SiteData{links: [], assets: []}
  end

  test "Adds links to site data" do
    links = ["https://gorka.io", "https://gorka.io/about"]

    actual = SiteData.new() |> SiteData.with_links(links)
    expected = %SiteData{links: links, assets: []}

    assert expected == actual
  end

  test "with_links replaces any existing links" do
    links_old = ["https://gorka.io", "https://gorka.io/about"]
    links_new = ["https://elixirconf.eu", "https://elixir-lang.org"]

    actual =
      SiteData.new()
      |> SiteData.with_links(links_old)
      |> SiteData.with_links(links_new)

    expected = %SiteData{links: links_new, assets: []}

    assert expected == actual
  end

  test "Adds assets to site data" do
    assets = ["https://gorka.io/logo.svg", "https://gorka.io/about/me.jpg"]

    actual = SiteData.new() |> SiteData.with_assets(assets)
    expected = %SiteData{links: [], assets: assets}

    assert expected == actual
  end

  test "with_assets replaces any existing assets" do
    assets_old = ["https://gorka.io/logo.svg", "https://gorka.io/about/me.jpg"]
    assets_new = ["https://elixirconf.eu/logo.svg", "https://elixir-lang.org/logo.svg"]

    actual =
      SiteData.new()
      |> SiteData.with_assets(assets_old)
      |> SiteData.with_assets(assets_new)

    expected = %SiteData{links: [], assets: assets_new}

    assert expected == actual
  end
end
