# Bridge

Study about concurrency with Elixir.

This project get the distance about two points using postal code with reference.

The postal codes are in the USA, because in Brazil aI can not found.

We have in this project:

- Store: to get the file with postal codes and coordinates
- Navigator: To get the distance about postal code
- Cache: Use GenServer to make a cache assyncronous

You can get the data in: data/2016_Gaz_zcta_national.txt

## Usage

Start the aplication

```
iex -S mix
```

After that you can explore some features:

```
Bridge.PostalCode.Navigator.get_distance(postcode_1, postcode_2)
# 50.5
```
