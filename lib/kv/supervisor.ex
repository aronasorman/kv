defmodule Kv.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
                worker(Kv.Server, [HashDict.new]),
                worker(Kv.Frontend.Supervisor, []),
               ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Kv.Frontend.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
                worker(Kv.Frontend, []),
               ]

    supervise(children, strategy: :one_for_one)
  end
end