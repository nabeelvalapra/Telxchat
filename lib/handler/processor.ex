defmodule Telxchat.Handler.Processor do
  require Logger
  
  def parse(data) do
    data = String.rstrip(data)
    case data do
      "/" <> _ ->
        cleaned_data = String.trim_leading(data, "/")
                        |> String.split(" ", parts: 2)
        recip = hd(cleaned_data)
        msg = tl(cleaned_data) ++ ["\r\n"]
        {recip, msg}
      "" -> :empty
      _ -> :invalid_format
    end
  end

  def process(data, name) do
    case parse(data) do
      :empty -> {get_recip_pid(name), "\r\n"}
      :invalid_format -> {get_recip_pid(name), "Invalid Format\r\n"}
      {recip, msg} -> 
        case get_recip_pid(recip) do
          :invalid_pid -> 
            {get_recip_pid(name), "There is no such user '#{recip}'\n"} 
          pid ->
            {pid, msg}
        end
    end
  end

  def get_recip_pid(recip) do
    recip = String.to_atom(recip)
    case GenServer.whereis(recip) do
      nil -> :invalid_pid
      pid -> pid 
    end
  end
end
