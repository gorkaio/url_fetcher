# benchmark.exs
defmodule Benchmark do
  @moduledoc false
  def run(url) do
    Benchee.run(%{
      "url_fetcher" => fn -> UrlFetcher.fetch(url) end
    })
  end
end

[arg1] = System.argv
Benchmark.run(arg1)
