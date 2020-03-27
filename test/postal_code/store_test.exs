defmodule Bridge.StoreTest do
  use ExUnit.Case
  alias Bridge.PostalCode.Store

  doctest Bridge

  test "get_location/1" do
    Store.start_link()

    {latitude, logitude} = Store.get_geolocation("94062")

    assert is_float(latitude)
    assert is_float(logitude)
  end
end
