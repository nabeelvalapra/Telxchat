defmodule Telxchat.Handler.Command do
  use GenServer
  require Logger
  alias Telxchat.Handler.Processor

  def start_link(conn, name) do
    GenServer.start_link(__MODULE__, [conn, name], [name: name])
  end

  def put_msg(pid, message) do
    GenServer.cast(pid, {:put, message})
  end

  def init([conn, name]) do
    msg = "Your name is registered as #{name} \n"
    :gen_tcp.send(conn, msg)
    spawn_link(__MODULE__, :send_worker, [conn, name])
    {:ok, conn}
  end

  def send_worker(conn, name) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        case Processor.process(data) do
          {:no_data, message} ->
            nil
          {:invalid_pid, message} ->
            put_msg(name, "There is no such user")
          {recip_pid, message} -> 
            put_msg(recip_pid, message)
        end
        send_worker(conn, name)
      {:error, :closed} ->
        :ok
    end
  end

  def handle_cast({:put, message}, conn) do
    :gen_tcp.send(conn, message)
    {:noreply, conn}
  end
end
