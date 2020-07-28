defmodule UrlFetcher.Http.MockServer do
  @moduledoc """
  Mock server

  ## Routes

    - `/test` generates an html response page. Takes two query params:
      - links: list of link urls to embed in the html response body
      - assets: list of img urls to embed in the html response body
    - `/failure` generates an http error response. Takes one optional query param:
      - status: http status code to be returned
    - `/redirect` generates an http 301 redirect response. Takes one query param:
      - page: absolute url of page to be redirected to
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/test" do
    conn =
      conn
      |> fetch_query_params()

    query_params = %{"assets" => [], "links" => []} |> Map.merge(conn.query_params)
    success(conn, query_params["links"], query_params["assets"])
  end

  get "/failure" do
    conn =
      conn
      |> fetch_query_params()

    case conn.query_params do
      %{"status" => status} -> failure(conn, status |> String.to_integer())
      _ -> failure(conn, :bad_request)
    end
  end

  get "/redirect" do
    conn =
      conn
      |> fetch_query_params()

    case conn.query_params do
      %{"page" => page} -> redirect(conn, page)
      _ -> failure(conn, :bad_request)
    end
  end

  defp redirect(conn, page) do
    conn
    |> Plug.Conn.put_resp_header("Location", page)
    |> Plug.Conn.send_resp(:moved_permanently, "")
    |> halt()
  end

  defp success(conn, links, assets) do
    conn
    |> Plug.Conn.send_resp(:ok, html(links, assets))
  end

  defp failure(conn, status) do
    conn
    |> Plug.Conn.send_resp(status, "")
  end

  defp html(links, assets) do
    links_html =
      links
      |> Enum.map(&link(&1))

    assets_html =
      assets
      |> Enum.map(&image(&1))

    """
    <html>
      <body>#{links_html}#{assets_html}</body>
    </html>
    """
  end

  defp link(url) do
    "<a href=\"#{url}\">link</a>"
  end

  defp image(url) do
    "<img src=\"#{url}\" />"
  end
end
