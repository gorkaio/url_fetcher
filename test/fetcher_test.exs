defmodule FetcherTest do
  use ExUnit.Case
  doctest Fetcher

  @url "https://gorka.io/about/"

  test "accepts strings as input" do
    assert Fetcher.fetch(@url) == :ok
  end

  test "Rejects invalid URLs" do
    assert Fetcher.fetch(5) == {:error, :invalid_url}
  end
end
