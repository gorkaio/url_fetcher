# UrlFetcher

![Tests](https://github.com/gorkaio/url_fetcher/workflows/verify/badge.svg)

_UrlFetcher_ fetches URLs present in image and anchor tags in a given URL.

## Usage

### UrlFetcher

`UrlFetcher.fetch("https://myawesome.url/page.html")` will retrieve all link and image URLs present in `https://myawesome.url/page.html`, returning them as lists `links` and `assets` in `UrlFetcher.SiteData` struct.

Some options you can provide to the fetcher:

- `http_client`: HTTP Client to be used. Must comply with `UrlFetcher.Http.Client` behaviour. Defaults to `UrlFetcher.Http.Adapter.Poison`.
- `unique`: boolean. If set, removes duplicates from results. Defaults to `true`.
- `normalize`: transforms all urls to absolute if set to `:absolute`, or leaves them as they are with `:original`. Defaults to `original`.

### HTTP Client behaviour

HTTP Client behaviour is defined in `UrlFetcher.Http.Client`. You can choose whatever HTTP client you prefer as long as it complies with that behavior or you implement a wrapper. Note that, by default, HTTP Client _must_ follow redirects.

## Installation

The package is [available in Hex](https://hex.pm/packages/url_fetcher), and can be installed
by adding `url_fetcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:url_fetcher, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/url_fetcher/](https://hexdocs.pm/url_fetcher/).

