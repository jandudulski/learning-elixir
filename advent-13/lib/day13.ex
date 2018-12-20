defmodule Day13 do
  @moduledoc """
  Documentation for Day13.
  """

  @doc """
  Answer to part 1.

  ## Examples

      iex> Day13.part1("example1.txt")
      {7,3}

  """
  def part1(file_name) do
    file_name |> load_input() |> find_crash()
  end

  @doc """
  Answer to part 2.

  ## Examples

      iex> Day13.part2("example2.txt")
      {6,4}

  """
  def part2(file_name) do
    file_name |> load_input() |> find_last_cart()
  end

  def find_crash({map, tracks}) do
    case tick_and_stop(tracks, tracks |> Map.keys(), map) do
      {:crash, location} ->
        location

      tracks ->
        find_crash({map, tracks})
    end
  end

  def find_last_cart({map, tracks}) do
    tracks = tick_and_go(tracks, tracks |> Map.keys(), map)

    if Enum.count(tracks) == 1 do
      tracks |> Map.keys() |> List.first()
    else
      find_last_cart({map, tracks})
    end
  end

  def tick_and_stop(acc, [], _map), do: acc

  def tick_and_stop(acc, [current_location | tail], map) do
    {location, track} = Map.get(acc, current_location) |> move(current_location, map)

    if Map.has_key?(acc, location) do
      {:crash, location}
    else
      acc
      |> Map.delete(current_location)
      |> Map.put(location, track)
      |> tick_and_stop(tail, map)
    end
  end

  def tick_and_go(acc, [], _map), do: acc

  def tick_and_go(acc, [current_location | tail], map) do
    with {:ok, track} <- Map.fetch(acc, current_location),
         {location, track} <- track |> move(current_location, map) do
      if Map.has_key?(acc, location) do
        acc
        |> Map.delete(current_location)
        |> Map.delete(location)
        |> tick_and_go(tail, map)
      else
        acc
        |> Map.delete(current_location)
        |> Map.put(location, track)
        |> tick_and_go(tail, map)
      end
    else
      :error -> tick_and_go(acc, tail, map)
    end
  end

  def move({:left, cross_turn}, {x, y}, map) do
    with location = {x - 1, y} do
      case Map.get(map, location) do
        "-" ->
          {location, {:left, cross_turn}}

        "/" ->
          {location, {:down, cross_turn}}

        "\\" ->
          {location, {:up, cross_turn}}

        "+" ->
          case cross_turn do
            :left -> {location, {:down, next_turn(cross_turn)}}
            :straight -> {location, {:left, next_turn(cross_turn)}}
            :right -> {location, {:up, next_turn(cross_turn)}}
          end
      end
    end
  end

  def move({:right, cross_turn}, {x, y}, map) do
    with location = {x + 1, y} do
      case Map.get(map, location) do
        "-" ->
          {location, {:right, cross_turn}}

        "/" ->
          {location, {:up, cross_turn}}

        "\\" ->
          {location, {:down, cross_turn}}

        "+" ->
          case cross_turn do
            :right -> {location, {:down, next_turn(cross_turn)}}
            :straight -> {location, {:right, next_turn(cross_turn)}}
            :left -> {location, {:up, next_turn(cross_turn)}}
          end
      end
    end
  end

  def move({:up, cross_turn}, {x, y}, map) do
    with location = {x, y - 1} do
      case Map.get(map, location) do
        "|" ->
          {location, {:up, cross_turn}}

        "/" ->
          {location, {:right, cross_turn}}

        "\\" ->
          {location, {:left, cross_turn}}

        "+" ->
          case cross_turn do
            :right -> {location, {:right, next_turn(cross_turn)}}
            :straight -> {location, {:up, next_turn(cross_turn)}}
            :left -> {location, {:left, next_turn(cross_turn)}}
          end
      end
    end
  end

  def move({:down, cross_turn}, {x, y}, map) do
    with location = {x, y + 1} do
      case Map.get(map, location) do
        "|" ->
          {location, {:down, cross_turn}}

        "/" ->
          {location, {:left, cross_turn}}

        "\\" ->
          {location, {:right, cross_turn}}

        "+" ->
          case cross_turn do
            :left -> {location, {:right, next_turn(cross_turn)}}
            :straight -> {location, {:down, next_turn(cross_turn)}}
            :right -> {location, {:left, next_turn(cross_turn)}}
          end
      end
    end
  end

  def next_turn(:left), do: :straight
  def next_turn(:straight), do: :right
  def next_turn(:right), do: :left

  def load_input(file_name) when is_binary(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({_map = %{}, _tracks = %{}}, &parse_line/2)
  end

  def parse_line({line, y}, acc) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn
      {" ", _}, acc ->
        acc

      {"^", x}, {map, tracks} ->
        {Map.put(map, {x, y}, "|"), Map.put(tracks, {x, y}, {:up, :left})}

      {">", x}, {map, tracks} ->
        {Map.put(map, {x, y}, "-"), Map.put(tracks, {x, y}, {:right, :left})}

      {"<", x}, {map, tracks} ->
        {Map.put(map, {x, y}, "-"), Map.put(tracks, {x, y}, {:left, :left})}

      {"v", x}, {map, tracks} ->
        {Map.put(map, {x, y}, "|"), Map.put(tracks, {x, y}, {:down, :left})}

      {path, x}, {map, tracks} ->
        {Map.put(map, {x, y}, path), tracks}
    end)
  end
end
