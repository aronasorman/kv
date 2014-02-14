defmodule Kv.Frontend do
  use GenServer.Behaviour

  @name :frontend

  def start_link do
    :gen_server.start_link({:local, @name}, __MODULE__, [], [])
  end

  def init([]) do
    dispatch = :cowboy_router.compile urls
    {:ok, _} = :cowboy.start_http(:http, 100,
                                 [port: 8080],
                                 [env: [dispatch: dispatch]])
    {:ok, []}
  end

  defp urls do
    [{:_, [
          {"/", Kv.Frontend.URLHandler, []}
       ]
    }]
  end
end

defmodule Kv.Frontend.URLHandler do
  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply(200, [], "Hi there", req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end