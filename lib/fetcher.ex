defmodule Fetcher do
  @moduledoc """
  `Fetcher` fetches image and link URLs from a given page URL.
  """

  @default_http_client Fetcher.Http.Adapter.Poison

  @doc """
  Fetch image and link tags URLs.

  ## Parameters

    - url: String that represents the URL to parse

  """
  @spec fetch(Fetcher.Http.Client.url(), list) ::
          {:ok, Fetcher.Http.Client.body()} | {:error, term}
  def fetch(url, opts \\ [])

  def fetch(url, opts) when is_binary(url) do
    {client, opts} = Keyword.pop(opts, :http_client, @default_http_client)

    with {:ok, document} <- client.get(url, opts), {:ok, html} <- Floki.parse_document(document) do
      {:ok, images(html), links(html)}
    end
  end

  def fetch(_url, _opts) do
    {:error, :invalid_url}
  end

  defp images(html) do
    Floki.find(html, "img")
    |> Floki.attribute("src")
  end

  defp links(html) do
    Floki.find(html, "a")
    |> Floki.attribute("href")
  end
end
