defmodule Kv do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    :ok = :application.start :crypto
    :ok = :application.start :ranch
    :ok = :application.start :cowlib
    :ok = :application.start :cowboy
    Kv.Supervisor.start_link
  end

  def stop(_state) do
    :application.stop :cowboy
    :application.stop :ranch
    :application.stop :cow_lib
  end
end