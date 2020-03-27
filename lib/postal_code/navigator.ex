defmodule Bridge.PostalCode.Navigator do
  alias :math, as: Math
  alias Bridge.PostalCode.Store

  # @radius 6371 #km
  @radius 3959

  def get_distance(from, to) do
    do_get_distance(from, to)
  end

  defp do_get_distance(from, to) do
    {lat1, long1} = get_geolocation(from)
    {lat2, long2} = get_geolocation(to)

    calculate_distance({lat1, long1}, {lat2, long2})
  end

  defp get_geolocation(postal_code) when is_binary(postal_code) do
    Store.get_geolocation(postal_code)
  end

  defp get_geolocation(postal_code) when is_integer(postal_code) do
    postal_code = Integer.to_string(postal_code)
    get_geolocation(postal_code)
  end

  defp get_geolocation(postal_code) do
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
