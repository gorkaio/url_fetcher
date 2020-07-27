defmodule Fetcher do
  @moduledoc """
  Fetches asset and link URLs from a given page URL.
  """
  alias Fetcher.Http.Client, as: HttpClient
  alias Fetcher.SiteData

  @default_opts [
    http_client: Fetcher.Http.Adapter.Poison,
    unique: true
  ]

  @doc """
  Fetch image and link tags URLs.

  Available options:

    - http_client: HTTP Client to be used. Must comply with `Fetcher.Http.Client` behaviour. Defaults to `Fetcher.Http.Adapter.Poison`.
    - unique: boolean. If set, removes duplicates from results. Defaults to `true`.

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

    with {:fetch, {:ok, document}} <- {:fetch, client.get(url)},
         {:parse, {:ok, html}} <- {:parse, Floki.parse_document(document)} do
      data =
        SiteData.new()
        |> SiteData.with_assets(assets(html, unique))
        |> SiteData.with_links(links(html, unique))

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

  defp assets(html, unique), do: grep(html, {"img", "src"}, unique)
  defp links(html, unique), do: grep(html, {"a", "href"}, unique)
end
