defmodule Kv do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Kv.Supervisor.start_link
  end
end

defmodule KvServer do
  use GenServer.Behaviour

  @name :kvserver

  def get(key) do
    :gen_server.call(@name, {:get, key})
  end

  def put(key, value) do
    :gen_server.call(@name, {:insert, key, value})
  end

  def start_link(dict) do
    :gen_server.start_link({:local, @name}, __MODULE__, dict, [])
  end

  def init(dict) do
    { :ok, dict }
  end

  def handle_call({ :insert, key, value }, _from, dict) do
    newdict = Dict.put(dict, key, value)
    { :reply, :ok, newdict }
  end

  def handle_call({ :get, key }, _from, dict) do
    { :reply, dict[key], dict }
  end
end