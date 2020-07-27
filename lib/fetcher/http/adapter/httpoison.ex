defmodule Fetcher.Http.Adapter.Poison do
  @moduledoc """
  HTTPoison adapter for HttpClient behaviour
  """
  @behaviour Fetcher.Http.Client

  @default_opts [follow_redirect: true, max_redirect: 3]

  @spec get(String.t(), key: any) :: {:ok, Fetcher.Http.Client.body()} | {:error, term}
  def get(url, opts \\ []) do
    {headers, opts} = Keyword.pop(opts, :headers, [])

    case HTTPoison.get(url, headers, Keyword.merge(@default_opts, opts)) do
      {:ok, %{status_code: status, body: body}} when status >= 200 and status < 300 -> {:ok, body}
      {:ok, %{status_code: status}} -> {:error, status}
      {:error, %{reason: reason}} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end
end
