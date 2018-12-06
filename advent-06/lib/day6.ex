defmodule Day6 do
  @type coordinate :: {integer, integer}
  @type distance :: integer

  @doc """
  Find largest region with locations within distance.

  ## Examples

      iex> Day6.find_largest_region([
      ...>  "1, 1",
      ...>  "1, 6",
      ...>  "8, 3",
      ...>  "3, 4",
      ...>  "5, 5",
      ...>  "8, 9",
      ...> ], 32)
      16
  """
  @spec find_largest_region(list, distance) :: integer
  def find_largest_region(list, limit) do
    with coordinates <- parse_input(list),
         {{left, top}, {right, bottom}} <- find_edges(coordinates) do

      Enum.reduce(left..right, 0, fn x, acc ->
        Enum.reduce(top..bottom, acc, fn y, acc ->
          if region_value({x, y}, coordinates) < limit do
            acc + 1
          else
            acc
          end
        end)
      end)
    end
  end

  @doc """
  Find largest finite area.

  ## Examples

      iex> Day6.find_largest_area([
      ...>  "1, 1",
      ...>  "1, 6",
      ...>  "8, 3",
      ...>  "3, 4",
      ...>  "5, 5",
      ...>  "8, 9",
      ...> ])
      17
  """
  @spec find_largest_area(list) :: integer
  def find_largest_area(list) do
    with coordinates <- parse_input(list),
         {{left, top}, {right, bottom}} <- find_edges(coordinates) do
      board =
        for x <- left..right, y <- top..bottom, into: %{} do
          {_, list} = closest({x, y}, coordinates)
          {{x, y}, list}
        end

      {infinite, finite} =
        Enum.reduce(left..right, {MapSet.new(), %{}}, fn x, acc ->
          Enum.reduce(top..bottom, acc, fn y, {infinite, finite} ->
            with items <- board[{x, y}] do
              cond do
                Enum.count(board[{x, y}]) > 1 ->
                  {infinite, finite}

                x == left or x == right or y == top or y == bottom ->
                  {MapSet.put(infinite, List.first(items)), finite}

                true ->
                  {infinite, Map.update(finite, List.first(items), 1, &(&1 + 1))}
              end
            end
          end)
        end)

      finite
      |> Enum.reduce(0, fn {point, size}, acc ->
        if MapSet.member?(infinite, point) or size < acc, do: acc, else: size
      end)
    end
  end

  @doc """
  Find points closest to coordinate.

  ## Examples

      iex> Day6.closest({5, 1}, [
      ...>  {1, 1},
      ...>  {1, 6},
      ...>  {8, 3},
      ...>  {3, 4},
      ...>  {5, 5},
      ...>  {8, 9},
      ...> ])
      {4, [{5, 5}, {1, 1}]}
  """
  @spec closest(coordinate, [coordinate]) :: {distance, [coordinate]}
  def closest(location, [head | coordinates]) do
    with first_distance <- manhattan_distance(location, head) do
      coordinates
      |> Enum.reduce({first_distance, [head]}, fn coordinate, {distance, acc} ->
        with candidate <- manhattan_distance(location, coordinate) do
          cond do
            candidate > distance -> {distance, acc}
            candidate == distance -> {distance, [coordinate | acc]}
            candidate < distance -> {candidate, [coordinate]}
          end
        end
      end)
    end
  end

  @doc """
  Calculate region value for a coordinate.

  ## Examples

      iex> Day6.region_value({4, 3}, [
      ...>  {1, 1},
      ...>  {1, 6},
      ...>  {8, 3},
      ...>  {3, 4},
      ...>  {5, 5},
      ...>  {8, 9},
      ...> ])
      30
  """
  @spec region_value(coordinate, [coordinate]) :: integer
  def region_value(location, coordinates) do
    coordinates
    |> Enum.reduce(0, fn point, acc ->
      acc + manhattan_distance(location, point)
    end)
  end

  @doc """
  Parse input to coordinates list.

  ## Examples

      iex> Day6.parse_input([
      ...>  "1, 1",
      ...>  "1, 6",
      ...>  "8, 3",
      ...> ])
      [{1, 1}, {1, 6}, {8, 3}]
  """
  @spec parse_input([binary]) :: [coordinate]
  def parse_input(list) do
    list |> Enum.map(&parse_line/1)
  end

  @doc """
  Parse coordinates string to tuple.

  ## Examples

      iex> Day6.parse_line("101, 202")
      {101, 202}

  """
  @spec parse_line(binary) :: coordinate
  def parse_line(line) when is_binary(line) do
    line
    |> String.split(", ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc """
  Calculates Manhattan distance between coordinates.

  ## Examples

      iex> Day6.manhattan_distance({1, 6}, {5, 2})
      8

  """
  @spec manhattan_distance(coordinate, coordinate) :: distance
  def manhattan_distance({p1, p2}, {q1, q2}) do
    abs(p1 - q1) + abs(p2 - q2)
  end

  @doc """
  Find edges of the board.

  ## Examples

      iex> Day6.find_edges([{2, 5}, {3, 6}, {1, 4}])
      {{1, 4}, {3, 6}}

  """
  @spec find_edges([coordinate]) :: {coordinate, coordinate}
  def find_edges(coordinates = [head | _]) do
    coordinates
    |> Enum.reduce({head, head}, fn {x, y}, {{left, top}, {right, bottom}} ->
      {{min(x, left), min(y, top)}, {max(x, right), max(y, bottom)}}
    end)
  end
end
