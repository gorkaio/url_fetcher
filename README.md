# Fetcher

![Tests](https://github.com/gorkaio/fetcher/workflows/verify/badge.svg)

_Fetcher_ fetches URLs present in image and anchor tags in a given URL.

## Usage

### Fetcher

`Fetcher.fetch("https://myawesome.url/page.html")` will retrieve all link and image URLs present in `https://myawesome.url/page.html`, returning them as lists `links` and `assets` in `Fetcher.SiteData` struct.

Some options you can provide to the fetcher:

- `http_client`: HTTP Client to be used. Must comply with `Fetcher.Http.Client` behaviour. Defaults to `Fetcher.Http.Adapter.Poison`.
- `unique`: boolean. If set, removes duplicates from results. Defaults to `true`.

### HTTP Client behaviour

HTTP Client behaviour is defined in `Fetcher.Http.Client`. You can choose whatever HTTP client you prefer as long as it complies with that behavior or you implement a wrapper. Note that, by default, HTTP Client _must_ follow redirects.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fetcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fetcher, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fetcher](https://hexdocs.pm/fetcher).

