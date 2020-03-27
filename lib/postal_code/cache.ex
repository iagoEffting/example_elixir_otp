defmodule Bridge.PostalCode.Cache do
  use GenServer

  def start_link do
    IO.puts("==> PostalCode.Cache starting ....... OK!")
    GenServer.start_link(__MODULE__, %{}, name: :postal_code_cache)
  end

  def init(_) do
    state = %{
      distance: %{}
    }

    {:ok, state}
  end

  def set_distance(from, to, distance) do
    GenServer.cast(:postal_code_cache, {:set_distance, from, to, distance})
  end

  def get_distance(from, to) do
    GenServer.call(:postal_code_cache, {:get_distance, from, to})
  end

  # Callbacks
  def handle_call({:get_distance, from, to}, _from, state) do
    key = generate_key(from, to)
    distance = get_in(state, [:distance, key])

    {:reply, distance, state}
  end

  def handle_cast({:set_distance, from, to, distance}, state) do
    key = generate_key(from, to)
    state = put_in(state, [:distance, key], distance)

    IO.puts("==> Iniciando cache para {#{from} -> #{to}}")
    :timer.sleep(1000)
    IO.puts("==> Finalizando cache para {#{from} -> #{to}}")

    {:noreply, state}
  end

  defp generate_key(from, to) do
    MapSet.new([from, to])
  end
end
