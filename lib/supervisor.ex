defmodule Bridge.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :bridge_supervisor)
  end

  def init(_) do
    children = [
      supervisor(Bridge.PostalCode.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
