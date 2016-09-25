defmodule Telxchat.Handler.Supervisor do
  use Supervisor
  require Logger

  def start_link do 
    Supervisor.start_link(__MODULE__, [], name: :handler_supervisor)
  end

  def handle_commad(conn, name) do
    Logger.info "Requested to handle: #{name}"
    Supervisor.start_child(:handler_supervisor, [conn, name])
  end

  def init([]) do
    children = [
      worker(Telxchat.Handler.Command, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
