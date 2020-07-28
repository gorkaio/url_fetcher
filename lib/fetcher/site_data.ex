defmodule UrlFetcher.SiteData do
  @moduledoc """
  Holds information about parsed site
  """

  @enforce_keys [:links, :assets]
  defstruct(
    links: [],
    assets: []
  )

  @type t :: %__MODULE__{links: list(String.t()), assets: list(String.t())}

  @doc """
  Create new site data struct

  ## Examples

      iex> UrlFetcher.SiteData.new()
      %UrlFetcher.SiteData{links: [], assets: []}

  """
  @spec new :: UrlFetcher.SiteData.t()
  def new do
    %__MODULE__{links: [], assets: []}
  end

  @doc """
  Adds links to site data

  ## Parameters

    - links: list of url strings

  ## Examples

      iex> UrlFetcher.SiteData.new()
      ...>  |> UrlFetcher.SiteData.with_links(["https://gorka.io"])
      %UrlFetcher.SiteData{links: ["https://gorka.io"], assets: []}

  """
  @spec with_links(UrlFetcher.SiteData.t(), list(String.t())) :: UrlFetcher.SiteData.t()
  def with_links(data, links) do
    %__MODULE__{data | links: links}
  end

  @doc """
  Adds assets to site data

  ## Parameters

    - assets: list of asset url strings

  ## Examples

      iex> UrlFetcher.SiteData.new()
      ...>  |> UrlFetcher.SiteData.with_assets(["https://gorka.io/logo.svg"])
      %UrlFetcher.SiteData{links: [], assets: ["https://gorka.io/logo.svg"]}

  """
  @spec with_assets(UrlFetcher.SiteData.t(), list(String.t())) :: UrlFetcher.SiteData.t()
  def with_assets(data, assets) do
    %__MODULE__{data | assets: assets}
  end
end
