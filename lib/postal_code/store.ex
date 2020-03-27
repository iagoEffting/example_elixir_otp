defmodule Bridge.PostalCode.Store do
  use GenServer
  alias Bridge.PostalCode.DataParser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :postal_code_store)
  end

  def init(_) do
    {:ok, DataParser.parse_data()}
  end

  def get_geolocation(postal_code) do
    GenServer.call(:postal_code_store, {:get_geolocation, postal_code})
  end

  # Callbacks

  # Obtyer geolocalização pelo codigo postal
  # Precisa ser sincrono pois indiferente de quem chamar esse método esperar a latitude e longitude como resposta
  # primeiro valor deve ser o :reply
  # segundo valor é o que o local que chamou vai receber como resposta
  # terceiro valor é o novo estado no processo do GenServer
  def handle_call({:get_geolocation, postal_code}, _from, geolocation_data) do
    geolocation = Map.get(geolocation_data, postal_code)
    {:reply, geolocation, geolocation_data}
  end
end
