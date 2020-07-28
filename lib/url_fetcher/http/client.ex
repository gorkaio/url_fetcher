defmodule UrlFetcher.Http.Client do
  @moduledoc """
  Behaviour adapter for HTTP clients
  """

  @type url() :: String.t()
  @type body() :: String.t()

  @doc """
  Gets HTML body of a given URL.

  By default, HTTP Client should follow redirects.

  ### Parameters

    - url: url string of the page to fetch
    - options: keyword list of options passed to the http client

  """
  @callback get(url :: url, options :: [key: any]) :: {:ok, body} | {:error, term}
end
