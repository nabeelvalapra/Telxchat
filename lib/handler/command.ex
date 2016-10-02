defmodule Telxchat.Handler.Command do
  use GenServer
  require Logger

  def start_link(conn, name) do
    GenServer.start_link(__MODULE__, [conn, name], [name: name])
  end

  def init([conn, name]) do
    msg = "Your name is registered as #{name} \n"
    :gen_tcp.send(conn, msg)
    spawn_link(__MODULE__, :echo_worker, [conn, name])
    {:ok, conn}
  end

  def echo_worker(conn, name) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        :gen_tcp.send(conn, data)
        echo_worker(conn, name)
      {:error, :closed} -> :ok
    end
  end
end
