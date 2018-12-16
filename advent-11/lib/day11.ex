defmodule Day11 do
  @box_size 300

  @type coordinates :: {integer, integer}
  @type serial :: integer

  @doc """
  Answer question to part 1.

  ## Examples

      iex> Day11.part1(18)
      {{33, 45}, 29}

  """
  def part1(serial) do
    with matrix <- matrix(serial) do
      matrix_squares(matrix, 3)
      |> Enum.max_by(&elem(&1, 1))
    end
  end

  @doc """
  Answer question to part 2.

  ## Examples

      iex> Day11.part2(18)
      {16, {{90, 269}, 113}}

  """
  def part2(serial) do
    with matrix <- matrix(serial) do
      {_, squares_with_sizes} =
        2..300
        |> Enum.reduce({matrix, %{}}, fn square_size, {cache, acc} ->
          cache = matrix_squares_from_cache(matrix, cache, square_size)
          biggest = cache |> Enum.max_by(&elem(&1, 1))

          acc = Map.put(acc, square_size, {elem(biggest, 0), elem(biggest, 1)})

          {cache, acc}
        end)

      squares_with_sizes
      |> Enum.max_by(&elem(elem(&1, 1), 1))
    end
  end

  def matrix_squares_from_cache(matrix, cache, square_size) do
    for y <- 1..(@box_size - square_size + 1),
        x <- 1..(@box_size - square_size + 1),
        into: %{} do
      cache_power = Map.fetch!(cache, {x, y})
      {{x, y}, square_power_from_cache(matrix, cache_power, {x, y}, square_size)}
    end
  end

  def square_power_from_cache(matrix, cache, {startx, starty}, square_size) do
    power =
      Enum.reduce(startx..(startx + square_size - 1), cache, fn x, acc ->
        Map.fetch!(matrix, {x, starty + square_size - 1}) + acc
      end)

    Enum.reduce(starty..(starty + square_size - 2), power, fn y, acc ->
      Map.fetch!(matrix, {startx + square_size - 1, y}) + acc
    end)
  end

  def matrix_squares(matrix, square_size) do
    for y <- 1..(@box_size - square_size + 1),
        x <- 1..(@box_size - square_size + 1),
        into: %{} do
      {{x, y}, square_power(matrix, {x, y}, square_size)}
    end
  end

  def matrix(serial) do
    for y <- 1..@box_size, x <- 1..@box_size, into: %{} do
      {{x, y}, cell_power({x, y}, serial)}
    end
  end

  def square_power(matrix, {startx, starty}, square_size) do
    Enum.reduce(startx..(startx + square_size - 1), 0, fn x, acc ->
      Enum.reduce(starty..(starty + square_size - 1), acc, fn y, acc ->
        Map.get(matrix, {x, y}, 0) + acc
      end)
    end)
  end

  @doc """
  Calculate cell power.

  ## Examples

      iex> Day11.cell_power({3, 5}, 8)
      4
      iex> Day11.cell_power({122, 79}, 57)
      -5
      iex> Day11.cell_power({217, 196}, 39)
      0
      iex> Day11.cell_power({101, 153}, 71)
      4

  """
  @spec cell_power(coordinates, serial) :: integer
  def cell_power({x, y}, serial) do
    rack_id = x + 10

    ((rack_id * y + serial) * rack_id)
    |> Integer.digits()
    |> Enum.at(-3, 0)
    |> (&(&1 - 5)).()
  end
end
