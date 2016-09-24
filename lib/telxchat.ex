defmodule Telxchat do
  use Application
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Telxchat.TCP.Supervisor, [])
    ] 
  
    Supervisor.start_link(children, [name: __MODULE__, strategy: :one_for_one])
  end
end
