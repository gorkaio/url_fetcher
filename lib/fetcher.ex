defmodule Fetcher do
  @moduledoc """
  Fetches asset and link URLs from a given page URL.
  """
  alias Fetcher.Http.Client, as: HttpClient
  alias Fetcher.SiteData

  @default_http_client Fetcher.Http.Adapter.Poison

  @doc """
  Fetch image and link tags URLs.

  ## Parameters

    - url: String that represents the URL to parse

  """
  @spec fetch(HttpClient.url(), key: any()) :: {:ok, SiteData.t()} | {:error, term}
  def fetch(url, opts \\ [])

  def fetch(url, opts) when is_binary(url) do
    {client, opts} = Keyword.pop(opts, :http_client, @default_http_client)

    with {:ok, document} <- client.get(url, opts), {:ok, html} <- Floki.parse_document(document) do
      {:ok, SiteData.new() |> SiteData.with_assets(images(html)) |> SiteData.with_links(links(html))}
    end
  end

  def fetch(_url, _opts) do
    {:error, :invalid_url}
  end

  defp images(html) do
    html
    |> Floki.find("img")
    |> Floki.attribute("src")
  end

  defp links(html) do
    html
    |> Floki.find("a")
    |> Floki.attribute("href")
  end
end
