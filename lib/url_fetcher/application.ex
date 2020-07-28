defmodule UrlFetcher.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    children =
      case args do
        [env: :prod] -> []
        [env: :test] -> [{Plug.Cowboy, scheme: :http, plug: UrlFetcher.Http.MockServer, options: [port: 8081]}]
        [env: :dev] -> []
        [_] -> []
      end

    opts = [strategy: :one_for_one, name: UrlFetcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
