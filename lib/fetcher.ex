defmodule Fetcher do
  @moduledoc """
  `Fetcher` fetches image and link URLs from a given page URL.
  """
  @type url() :: String.t()

  @doc """
  Fetch image and link tags URLs.

  ## Parameters

    - url: String that represents the URL to parse

  ## Examples

      iex> Fetcher.fetch("https://google.com")
      :ok

  """
  @spec fetch(url) :: :ok | {:error, term}
  def fetch(url) when is_binary(url) do
    :ok
  end

  def fetch(_url) do
    {:error, :invalid_url}
  end
end
