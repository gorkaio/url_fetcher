defmodule UrlFetcher.ParserTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest UrlFetcher.Parser
  alias UrlFetcher.Parser

  test "Parses tag attributes from HTML" do
    document = """
    <html>
      <body>
        <p><a href="https://gorka.io">Home</a></p>
        <p><a href="https://gorka.io/about">About</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["https://gorka.io", "https://gorka.io/about"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"})

    assert expected == actual
  end

  test "Keeps duplicates if required" do
    document = """
    <html>
      <body>
        <p><a href="https://gorka.io">Home</a></p>
        <p><a href="https://gorka.io/about">About</a></p>
        <p><a href="https://gorka.io/about">About</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["https://gorka.io", "https://gorka.io/about", "https://gorka.io/about"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"}, unique: false)

    assert expected == actual
  end

  test "Removes duplicates if required" do
    document = """
    <html>
      <body>
        <p><a href="https://gorka.io">Home</a></p>
        <p><a href="https://gorka.io/about">About</a></p>
        <p><a href="https://gorka.io/about">About</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["https://gorka.io", "https://gorka.io/about"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"}, unique: true)

    assert expected == actual
  end

  test "Normalizes URLs to absolute if required" do
    document = """
    <html>
      <body>
        <p><a href="#home">Home</a></p>
        <p><a href="about/me.html">About</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["https://gorka.io#home", "https://gorka.io/about/me.html"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"}, normalize: :absolute)

    assert expected == actual
  end

  test "Keeps URLs as they were if required" do
    document = """
    <html>
      <body>
        <p><a href="#home">Home</a></p>
        <p><a href="about/me.html">About</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["#home", "about/me.html"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"}, normalize: :original)

    assert expected == actual
  end

  test "Filtering out external links is configurable via options" do
    document = """
    <html>
      <body>
        <p><a href="#home">Home</a></p>
        <p><a href="https://gorka.io/about.html">About</a></p>
        <p><a href="test/about.html">About test</a></p>
        <p><a href="https://elixir-lang.org/install.html">Elixir</a></p>
      </body>
    </html>
    """

    {:ok, html} = Floki.parse_document(document)

    expected = ["#home", "https://gorka.io/about.html", "test/about.html"]
    actual = Parser.parse(html, "https://gorka.io", {"a", "href"}, internal_only: true)

    assert expected == actual
  end
end
