defmodule Bridge.PostalCode.CacheTest do
  use ExUnit.Case
  alias Bridge.PostalCode.Cache
  doctest Bridge

  test "get_and_set_distance" do
    p1 = "12342"
    p2 = "43534"
    distance = 99.98

    Cache.set_distance(p1, p2, distance)

    retrieved_distance = Cache.get_distance(p1, p2)

    assert distance == retrieved_distance
  end
end
