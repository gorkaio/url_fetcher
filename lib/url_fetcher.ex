defmodule UrlFetcher do
  @moduledoc """
  Fetches asset and link URLs from a given page URL.
  """
  alias UrlFetcher.Http.Client, as: HttpClient
  alias UrlFetcher.SiteData

  @default_opts [
    http_client: UrlFetcher.Http.Adapter.Poison,
    unique: true,
    normalize: :original
  ]

  @doc """
  Fetch image and link tags URLs.

  Available options:

    - http_client: HTTP Client to be used. Must comply with `UrlFetcher.Http.Client` behaviour. Defaults to `UrlFetcher.Http.Adapter.Poison`.
    - unique: boolean. If set, removes duplicates from results. Defaults to `true`.
    - normalize: transforms all urls to absolute if set to :absolute, or leaves them as they are with :original. Defaults to `original`.

    ## Parameters

    - url: String that represents the URL to parse
    - opts: Keyword list of options

  """
  @spec fetch(HttpClient.url(), key: any()) :: {:ok, SiteData.t()} | {:error, term}
  def fetch(url, opts \\ [])

  def fetch(url, opts) when is_binary(url) do
    opts = Keyword.merge(@default_opts, opts)
    client = Keyword.get(opts, :http_client)
    unique = Keyword.get(opts, :unique)
    normalize = Keyword.get(opts, :normalize)

    with {:fetch, {:ok, document}} <- {:fetch, client.get(url)},
         {:parse, {:ok, html}} <- {:parse, Floki.parse_document(document)} do
      data =
        SiteData.new()
        |> SiteData.with_assets(assets(html, unique) |> Enum.map(&normalize(&1, url, normalize)))
        |> SiteData.with_links(links(html, unique) |> Enum.map(&normalize(&1, url, normalize)))

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

  defp grep(html, {tag, attribute}, unique) do
    items =
      html
      |> Floki.find(tag)
      |> Floki.attribute(attribute)

    case unique do
      true -> Enum.uniq(items)
      _ -> items
    end
  end

  defp normalize(url, _base_url, :original), do: url

  defp normalize(url, base_url, :absolute) do
    %{host: url_host} = URI.parse(url)

    case url_host do
      nil -> URI.merge(base_url, url) |> URI.to_string()
      _ -> url
    end
  end

  defp assets(html, unique), do: grep(html, {"img", "src"}, unique)
  defp links(html, unique), do: grep(html, {"a", "href"}, unique)
end
