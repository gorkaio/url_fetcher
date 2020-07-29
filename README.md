# UrlFetcher

![Tests](https://github.com/gorkaio/url_fetcher/workflows/verify/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/gorkaio/url_fetcher/badge.svg?branch=master)](https://coveralls.io/github/gorkaio/url_fetcher?branch=master)

_UrlFetcher_ fetches URLs present in image and anchor tags in a given URL.

## Usage

### UrlFetcher

`UrlFetcher.fetch("https://myawesome.url/page.html")` will retrieve all link and image URLs present in `https://myawesome.url/page.html`, returning them as lists `links` and `assets` in `UrlFetcher.SiteData` struct.

Some options you can provide to the fetcher:

- `http_client`: HTTP Client to be used. Must comply with `UrlFetcher.Http.Client` behaviour. Defaults to `UrlFetcher.Http.Adapter.Poison`.
- `unique`: boolean. If set, removes duplicates from results. Defaults to `true`.
- `normalize`: transforms all urls to absolute if set to `:absolute`, or leaves them as they are with `:original`. Defaults to `original`.
- `internal_only`: boolean. If set, filters urls to the ones internal to the site being fetched. Defaults to `false`.

### HTTP Client behaviour

HTTP Client behaviour is defined in `UrlFetcher.Http.Client`. You can choose whatever HTTP client you prefer as long as it complies with that behavior or you implement a wrapper. Note that, by default, HTTP Client _must_ follow redirects.

## Installation

The package is [available in Hex](https://hex.pm/packages/url_fetcher), and can be installed
by adding `url_fetcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:url_fetcher, "~> 0.2.2"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/url_fetcher/](https://hexdocs.pm/url_fetcher/).

## Contributing

Please have a look at the [contributing guidelines](CONTRIBUTING.md).

_Url Fetcher_ has some automated CI Github actions that will take care of reviewing any pull request:

- Check code formatting
- Check tests pass
- Check static analysis with dialyzer
- Submit any code style suggestions and improvements as comments on the PR

Once everything looks good, your PR will be merged. Every push to the main branch will trigger an automated publishing of the package and documentation to [hex](https://hex.pm).

### Test coverage

You can run a test coverage report with `mix coveralls`.

### Benchmarking

In order to improve performance it is important to actually benchmark the code. _UrlFetcher_ uses [benchee](https://hex.pm/packages/benchee) for than. Have a look at [benchmark.exs](bin/benchmark.exs) and compare your implementation against the current code before submitting a pull request. Run the benchmark with `mix run bin/benchmark.exs <url>`.
