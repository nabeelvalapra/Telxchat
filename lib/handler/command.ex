defmodule Telxchat.Handler.Command do
  use GenServer
  require Logger

  def start_link(conn, name) do
    GenServer.start_link(__MODULE__, conn)
  end

  def init(conn) do
    spawn_link(__MODULE__, :echo_worker, [conn])
    {:ok, conn}
  end

  def echo_worker(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        Logger.info "Got :: #{data}"
        :gen_tcp.send(conn, data)
        init(conn)
      {:error, :closed} -> :ok
    end

  end
end
