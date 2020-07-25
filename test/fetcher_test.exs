defmodule FetcherTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest Fetcher
  import Mox

  @url "https://gorka.io/about/"

  setup :verify_on_exit!

  test "Rejects invalid URLs" do
    assert Fetcher.fetch(5) == {:error, :invalid_url}
  end

  test "Returns empty lists for pages without images or links" do
    html = data("empty")

    Fetcher.HttpClientMock
    |> expect(:get, fn @url, _options -> {:ok, html} end)

    assert Fetcher.fetch(@url, http_client: Fetcher.HttpClientMock) == {:ok, [], []}
  end

  test "Reads single image from html pages" do
    html = data("image_only")

    Fetcher.HttpClientMock
    |> expect(:get, fn @url, _options -> {:ok, html} end)

    assert Fetcher.fetch(@url, http_client: Fetcher.HttpClientMock) ==
             {:ok, ["https://www.elixirconf.eu/assets/images/logo.svg"], []}
  end

  test "Reads single link from html pages" do
    html = data("link_only")

    Fetcher.HttpClientMock
    |> expect(:get, fn @url, _options -> {:ok, html} end)

    assert Fetcher.fetch(@url, http_client: Fetcher.HttpClientMock) ==
             {:ok, [], ["https://www.elixirconf.eu"]}
  end

  test "Reads multiple images and links from html pages" do
    html = data("images_and_links")

    Fetcher.HttpClientMock
    |> expect(:get, fn @url, _options -> {:ok, html} end)

    assert Fetcher.fetch(@url, http_client: Fetcher.HttpClientMock) ==
             {:ok, ["https://www.elixirconf.eu/assets/images/logo.svg", "/images/logo/logo.png"],
              ["#books", "#courses", "#other-resources", "#screencasts", "#in-depth-resources"]}
  end

  defp data(test) do
    {:ok, content} =
      Path.expand(__DIR__)
      |> Path.join("data")
      |> Path.join(filename(test))
      |> File.read()

    content
  end

  defp filename(test) do
    "test_" <> test <> ".html"
  end
end
