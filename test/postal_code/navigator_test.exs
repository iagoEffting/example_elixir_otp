defmodule Bridge.PostalCode.NavigatorTest do
  use ExUnit.Case
  alias Bridge.PostalCode.Navigator
  doctest Bridge

  describe "get_distance format test" do
    test "postal code strings" do
      distance = Navigator.get_distance("94062", "94104")
      assert is_float(distance)
    end

    test "postal code integers" do
      distance = Navigator.get_distance(94062, "94104")
      assert is_float(distance)
    end

    test "postal code strings and integers" do
      distance = Navigator.get_distance(94062, "94104")
      assert is_float(distance)
    end

    test "postal code unexpected format" do
      assert_raise ArgumentError, fn ->
        Navigator.get_distance("94062", 9451.54548)
      end
    end
  end

  # SF -> NY: 2565.28
  # MNPLS -> AUSTIN: 1044.08
  # RWC -> SF: 26.75

  describe "get_distance (actual distance)" do
    test "distance_between_rwc_and_sf" do
      # Redwood City, CA 94062
      # San Francisco, CA 94104
      # Driving distance ~ 40 miles
      distance = Navigator.get_distance(94062, 94104)
      # IO.puts("RWC -> SF: #{distance}")
      assert(distance == 26.75)
    end

    test "distance_between_sf_and_nyc" do
      # San Francisco, CA 94104
      # New York, NY 10112
      # Driving distance ~ 3100 miles
      distance = Navigator.get_distance(94104, 10112)
      # IO.puts("SF -> NY: #{distance}")
      assert(distance == 2565.28)
    end

    test "distance_between_mnpls_and_austin" do
      # Minneapolis, MN 55401
      # Austin, TX 78703
      # Driving distance ~ 1100 miles
      distance = Navigator.get_distance(55401, 78703)
      # IO.puts("MNPLS -> AUSTIN: #{distance}")
      assert(distance == 1044.08)
    end
  end
end
