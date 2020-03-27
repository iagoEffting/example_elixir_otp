defmodule Bridge.DataParserTest do
  use ExUnit.Case
  alias Bridge.PostalCode.DataParser

  doctest Bridge

  test "parse_data/0" do
    geolocation_data = DataParser.parse_data()
    {latitude, longitude} = Map.get(geolocation_data, "94062")

    assert(is_float(latitude))
    assert(is_float(longitude))
  end
end
