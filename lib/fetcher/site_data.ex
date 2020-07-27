defmodule Fetcher.SiteData do
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

      iex> Fetcher.SiteData.new()
      %Fetcher.SiteData{links: [], assets: []}

  """
  @spec new :: Fetcher.SiteData.t()
  def new do
    %__MODULE__{links: [], assets: []}
  end

  @doc """
  Adds links to site data

  ## Parameters

    - links: list of url strings

  ## Examples

      iex> Fetcher.SiteData.new()
      ...>  |> Fetcher.SiteData.with_links(["https://gorka.io"])
      %Fetcher.SiteData{links: ["https://gorka.io"], assets: []}

  """
  @spec with_links(Fetcher.SiteData.t(), list(String.t())) :: Fetcher.SiteData.t()
  def with_links(data, links) do
    %__MODULE__{data | links: links}
  end

  @doc """
  Adds assets to site data

  ## Parameters

    - assets: list of asset url strings

  ## Examples

      iex> Fetcher.SiteData.new()
      ...>  |> Fetcher.SiteData.with_assets(["https://gorka.io/logo.svg"])
      %Fetcher.SiteData{links: [], assets: ["https://gorka.io/logo.svg"]}

  """
  @spec with_assets(Fetcher.SiteData.t(), list(String.t())) :: Fetcher.SiteData.t()
  def with_assets(data, assets) do
    %__MODULE__{data | assets: assets}
  end
end
