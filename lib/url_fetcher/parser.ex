defmodule UrlFetcher.Parser do
  @moduledoc """
  HTML parser module
  """
  alias UrlFetcher.Http.Client, as: HttpClient

  @default_opts [
    unique: true,
    normalize: :original,
    internal_only: false
  ]

  @doc """
  Parses an HTML document extracting URLs from attribute value for given tags.
  Assumes given attribute values to be URLs.

  ## Parameters

    - html: String. HTML content.
    - base_url: String. Base url of the given content, used for absolute url normalization.
    - tag: String. HTML tag to look for.
    - attribute: String. HTML Tag attribute to extract.
    - opts: [key: value]. Options for the parser.

    Available options:

    - unique: Boolean. If set, removes duplicates from results. Defaults to `true`.
    - normalize: Atom. Transforms all urls to absolute if set to `:absolute`, or leaves them as they are with `:original`. Defaults to `:original`.
    - internal_only: Boolean. If set, filters urls to those internal to the site being fetched. Defaults to `false`.

  """
  @spec parse(Floki.html_tree(), HttpClient.url(), {String.t(), String.t()}, key: any()) :: [HttpClient.url()]
  def parse(html, base_url, {tag, attribute}, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    grep(html, {tag, attribute})
    |> uniq(Keyword.get(opts, :unique))
    |> Enum.map(&normalize(&1, base_url, Keyword.get(opts, :normalize)))
    |> filter_internal(base_url, Keyword.get(opts, :internal_only))
  end

  defp grep(html, {tag, attribute}) do
    html
    |> Floki.find(tag)
    |> Floki.attribute(attribute)
  end

  defp uniq(items, true), do: Enum.uniq(items)
  defp uniq(items, _), do: items

  defp normalize(url, _base_url, :original), do: url

  defp normalize(url, base_url, :absolute) do
    %{host: url_host} = URI.parse(url)

    case url_host do
      nil -> URI.merge(base_url, url) |> URI.to_string()
      _ -> url
    end
  end

  defp filter_internal(urls, base_url, true) do
    urls
    |> Enum.filter(&is_internal(&1, base_url))
  end

  defp filter_internal(urls, _base_url, _), do: urls

  defp is_internal(url, base_url) do
    %{host: url_host} = URI.parse(url)
    %{host: base_host} = URI.parse(base_url)
    url_host == nil || url_host == base_host
  end
end
