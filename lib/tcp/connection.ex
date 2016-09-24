defmodule Telxchat.TCP.Connection do 
  use GenServer
  alias Telxchat.Handler
  require Logger
  
  @opts [:binary, packet: :line, active: false, reuseaddr: true, exit_on_close: true]

  def start_link do
    GenServer.start_link(__MODULE__, 4000, [])
  end

  def init(port) do
    {:ok, socket} = :gen_tcp.listen(port, @opts)
    Logger.info "Listening to #{port} !!!"
    Task.start_link(fn -> listen_for_conn(socket) end)
  end

  def listen_for_conn(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    Logger.info "Got new connections"
    name = worker_name(conn)
    Handler.Supervisor.handle_commad(conn, name)
    listen_for_conn(socket)
  end

  def worker_name(conn) do
    {:ok, {{a, b, c, d}, _}} = :inet.peername(conn)
    :"#{a}.#{b}.#{c}.#{d}"
  end
end
