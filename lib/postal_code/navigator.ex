defmodule Bridge.PostalCode.Navigator do
  use GenServer

  alias :math, as: Math
  alias Bridge.PostalCode.Cache
  alias Bridge.PostalCode.Store

  @radius 6371

  def start_link do
    IO.puts("==> PostalCode.Navigator starting ... OK!")

    GenServer.start_link(__MODULE__, [], name: :postal_code_navigator)
  end

  def init(_) do
    {:ok, []}
  end

  def get_distance(from, to) do
    GenServer.call(:postal_code_navigator, {:get_distance, from, to})
  end

  # Callbacks
  def handle_call({:get_distance, from, to}, _from, state) do
    distance = do_get_distance(from, to)
    {:reply, distance, state}
  end

  defp do_get_distance(from, to) do
    from = format_postal_code(from)
    to = format_postal_code(to)

    case Cache.get_distance(from, to) do
      nil ->
        IO.puts("=> Not use cache")
        {lat1, long1} = get_geolocation(from)
        {lat2, long2} = get_geolocation(to)

        distance = calculate_distance({lat1, long1}, {lat2, long2})
        Cache.set_distance(from, to, distance)
        distance

      distance ->
        IO.puts("=> Use cache")
        distance
    end
  end

  defp get_geolocation(postal_code) do
    Store.get_geolocation(postal_code)
  end

  defp format_postal_code(postal_code) when is_binary(postal_code) do
    postal_code
  end

  defp format_postal_code(postal_code) when is_integer(postal_code) do
    postal_code = Integer.to_string(postal_code)
    format_postal_code(postal_code)
  end

  defp format_postal_code(postal_code) do
    error = "Unexpected `postal_code`, received: (#{inspect(postal_code)})"
    raise ArgumentError, error
  end

  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    # using math
    # great circle distance (https://en.wikipedia.org/wiki/Great-circle_distance)
    lat_diff = degress_to_radians(lat2 - lat1)
    long_diff = degress_to_radians(long2 - long1)

    lat1 = degress_to_radians(lat1)
    lat2 = degress_to_radians(lat2)

    cos_lat1 = Math.cos(lat1)
    cos_lat2 = Math.cos(lat2)

    sin_lat_dif_aq = Math.sin(lat_diff / 2) |> Math.pow(2)
    sin_long_dif_aq = Math.sin(long_diff / 2) |> Math.pow(2)

    a = sin_lat_dif_aq + cos_lat1 * cos_lat2 * sin_long_dif_aq
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    (@radius * c) |> Float.round(2)
  end

  defp degress_to_radians(degress) do
    degress * (Math.pi() / 180)
  end
end
