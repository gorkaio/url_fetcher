defmodule UrlFetcher.Http.MockServerTest do
  @moduledoc false
  use ExUnit.Case, async: true
  doctest UrlFetcher.Http.MockServer
  alias Plug.Conn.Query

  @base_url "http://localhost:8081/"
  @test_url @base_url <> "test"
  @redirect_url @base_url <> "redirect"
  @failure_url @base_url <> "failure"

  test "Generates empty page when no links or assets are given" do
    {:ok, response} = HTTPoison.get(@test_url)
    assert response.status_code == 200

    assert response.body == """
           <html>
             <body></body>
           </html>
           """
  end

  test "Generates page with given links and assets" do
    links = ["https://gorka.io", "https://gorka.io/about"]
    assets = ["https://gorka.io/logo.svg", "https://gorka.io/logo2.png"]
    params = %{links: links, assets: assets}

    url =
      @test_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(params))
      |> URI.to_string()

    {:ok, response} = HTTPoison.get(url)
    assert response.status_code == 200
    assert response.body =~ "<a href=\"https://gorka.io\">link</a>"
    assert response.body =~ "<a href=\"https://gorka.io/about\">link</a>"
    assert response.body =~ "<img src=\"https://gorka.io/logo.svg\" />"
    assert response.body =~ "<img src=\"https://gorka.io/logo2.png\" />"
  end

  test "Generates redirection" do
    redirect_to = @test_url

    url =
      @redirect_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(%{page: redirect_to}))
      |> URI.to_string()

    {:ok, response} = HTTPoison.get(url)
    assert response.status_code == 301
  end

  test "Redirection without location renders failure" do
    {:ok, response} = HTTPoison.get(@redirect_url)
    assert response.status_code == 400
  end

  test "Generates failure responses" do
    url =
      @failure_url
      |> URI.parse()
      |> Map.put(:query, Query.encode(%{status: 422}))
      |> URI.to_string()

    {:ok, response} = HTTPoison.get(url)
    assert response.status_code == 422
  end
end
