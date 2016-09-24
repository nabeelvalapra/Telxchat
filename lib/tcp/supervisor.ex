defmodule Telxchat.TCP.Supervisor do
  use Supervisor

  def start_link do 
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      supervisor(Telxchat.TCP.Connection, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
