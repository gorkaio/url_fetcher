defmodule Fetcher.Http.Adapter.Poison do
  @moduledoc """
  HTTPoison adapter for HttpClient behaviour
  """
  @behaviour Fetcher.Http.Client

  def get(url, opts \\ []) do
    {headers, opts} = Keyword.pop(opts, :headers, [])
    {:ok, response} = HTTPoison.get(url, headers, opts)
    response.body
  end
end
