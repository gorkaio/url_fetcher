defmodule Fetcher.Http.Client do
  @moduledoc """
  Behaviour adapter for HTTP clients
  """

  @type url() :: String.t()
  @type body() :: String.t()

  @callback get(url :: url, options :: list) :: {:ok, body} | {:error, term}
end
