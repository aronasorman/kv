defmodule Kv.Frontend do
  use GenServer.Behaviour

  @name :frontend

  def start_link do
    :gen_server.start_link({:local, @name}, __MODULE__, [], [])
  end

  def init([]) do
    {:ok, :templates} = :erlydtl.compile_dir('lib/templates', :templates)
    dispatch = :cowboy_router.compile urls
    {:ok, _} = :cowboy.start_http(:http, 100,
                                 [port: 8080],
                                 [env: [dispatch: dispatch]])
    {:ok, []}
  end

  defp urls do
    [{:_, [
          {"/", Kv.Frontend.NewURLHandler, []},
          {"/:key", Kv.Frontend.RedirectHandler, []},
       ]
    }]
  end
end

defmodule Kv.Frontend.NewURLHandler do
  defrecord State, templates: nil

  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  def handle(req, state) do
    rep = :templates.enter_url []
    {:ok, req} = :cowboy_req.reply(200, [], rep, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end

defmodule Kv.Frontend.RedirectHandler do
  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  def handle(req, state) do
  end

  def terminate(_reason, _req, _state) do
  end
end