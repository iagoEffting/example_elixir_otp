defmodule Bridge.PostalCode.Supervisor do
  use Supervisor

  alias Bridge.PostalCode.Store
  alias Bridge.PostalCode.Navigator
  alias Bridge.PostalCode.Cache

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :postal_code_supervisor)
  end

  def init(_) do
    children = [
      worker(Store, []),
      worker(Navigator, []),
      worker(Cache, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
