defmodule Fetcher.Http.Adapter.Poison do
  @moduledoc """
  HTTPoison adapter for HttpClient behaviour
  """
  @behaviour Fetcher.Http.Client

  def get(url, opts \\ []) do
    {headers, opts} = Keyword.pop(opts, :headers, [])

    {:ok, response} =
      HTTPoison.get(url, headers, opts |> Keyword.put_new(:follow_redirect, true) |> Keyword.put_new(:max_redirect, 3))

    response.body
  end
end
