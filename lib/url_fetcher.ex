defmodule UrlFetcher do
  @moduledoc """
  Fetches asset and link URLs from a given page URL.
  """
  alias UrlFetcher.Http.Client, as: HttpClient
  alias UrlFetcher.Parser
  alias UrlFetcher.SiteData

  @default_opts [
    http_client: UrlFetcher.Http.Adapter.Poison,
    unique: true,
    normalize: :original
  ]

  @doc """
  Fetch image and link tags URLs.

  ## Parameters

    - url: String that represents the URL to parse
    - opts: Keyword list of options

    Available options:

    - http_client: HTTP Client to be used. Must comply with `UrlFetcher.Http.Client` behaviour. Defaults to `UrlFetcher.Http.Adapter.Poison`.
    - unique: boolean. If set, removes duplicates from results. Defaults to `true`.
    - normalize: transforms all urls to absolute if set to :absolute, or leaves them as they are with :original. Defaults to `original`.

  """
  @spec fetch(HttpClient.url(), key: any()) :: {:ok, SiteData.t()} | {:error, term}
  def fetch(url, opts \\ [])

  def fetch(url, opts) when is_binary(url) do
    opts = Keyword.merge(@default_opts, opts)
    {client, opts} = Keyword.pop(opts, :http_client)

    with {:fetch, {:ok, document}} <- {:fetch, client.get(url)},
         {:parse, {:ok, html}} <- {:parse, Floki.parse_document(document)} do
      results =
        %{assets: {"img", "src"}, links: {"a", "href"}}
        |> Task.async_stream(fn {k, v} -> {k, Parser.parse(html, url, v, opts)} end)
        |> Enum.map(fn {:ok, {k, result}} -> {k, result} end)

      data =
        SiteData.new()
        |> SiteData.with_assets(results[:assets])
        |> SiteData.with_links(results[:links])

      {:ok, data}
    else
      {:fetch, {:error, reason}} -> {:error, reason}
      {:parse, {:error, reason}} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end

  def fetch(_url, _opts) do
    {:error, :invalid_url}
  end
end
