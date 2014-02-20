defmodule Kv.Frontend do
  use GenServer.Behaviour

  @name :frontend

  def start_link do
    :gen_server.start_link({:local, @name}, __MODULE__, [], [])
  end

  def init([]) do
    IO.puts "Compiling the templates."
    :erlydtl.compile_dir('lib/templates', :templates, [out_dir: Mix.Project.build_path])
    dispatch = :cowboy_router.compile urls
    {:ok, _} = :cowboy.start_http(:http, 100,
                                 [port: 8080],
                                 [env: [dispatch: dispatch]])
    {:ok, []}
  end

  defp urls do
    [{:_, [
          {"/", Kv.Frontend.NewURLEntryHandler, []},
          {"/create", Kv.Frontend.CreateUrlEntryHandler, []},
          {"/k/:key", Kv.Frontend.RedirectHandler, []},
       ]
    }]
  end
end

defmodule Kv.Frontend.NewURLEntryHandler do
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

defmodule Kv.Frontend.CreateUrlEntryHandler do
  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  def handle(req, state) do
    {method, _req} = :cowboy_req.method(req)
    case method do
      "POST" ->
        {:ok, params, req} = :cowboy_req.body_qs(req)
        {:ok, key} = store_url params["url"]
        {:ok, req} = :cowboy_req.reply(200, [], key, req)
        {:ok, req, state}
      "GET" ->
        {:ok, req, state}
    end
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  defp store_url(url) do
    digest = :crypto.hash :md5, url
    hexdigest = (hexstring digest) |> Enum.take 7
    Kv.Server.put hexdigest, url
    {:ok, hexdigest}
  end

  defp hexstring(bin) do
    ints = bitstring_to_list bin
    Enum.flat_map ints, &(:io_lib.format('~2.16.0b', [&1]) |> :lists.flatten)
  end
end