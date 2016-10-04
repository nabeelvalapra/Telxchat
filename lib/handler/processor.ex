defmodule Telxchat.Handler.Processor do
  require Logger
  
  def process(data) do
    [recip, msg] = String.trim_leading(data, "/")
                    |> String.split(" ", parts: 2) 
    recip_pid = get_recip_pid(recip)
    {recip_pid, msg}
  end

  def get_recip_pid(recip) do
    recip = String.to_atom(recip)
    case GenServer.whereis(recip) do
      nil ->
        :invalid_pid
      pid ->
         pid 
    end
  end
end
