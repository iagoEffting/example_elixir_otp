defmodule Bridge do
  use Application

  def start(_type, _args) do
    Bridge.Supervisor.start_link()
  end
end
