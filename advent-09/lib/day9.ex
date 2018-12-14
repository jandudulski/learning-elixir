defmodule Day9 do
  @moduledoc """
  Documentation for Day9.
  """

  @doc """
  Respond to part 1.

  ## Examples

      iex> Day9.part1(9, 25)
      32
      iex> Day9.part1(10, 1618)
      8317
      iex> Day9.part1(13, 7999)
      146373
      iex> Day9.part1(17, 1104)
      2764
      iex> Day9.part1(21, 6111)
      54718
      iex> Day9.part1(30, 5807)
      37305

  """
  @spec part1(integer, integer) :: integer
  def part1(players, last_marble) do
    points = for p <- 0..(players - 1), into: %{}, do: {p, 0}

    {_, _, _, points, _} =
      2..last_marble
      |> Enum.reduce({[0], 1, [], points, 0}, fn marble, {behind, current, infront, points, player} ->
        # IO.inspect(marble, label: "Current marble")
        {score, behind, current, infront} = insert_marble(marble, behind, current, infront)
        points = Map.update!(points, player, &(&1 + score))

        {behind, current, infront, points, rem(player + 1, players)}
      end)

    points |> IO.inspect(label: "points") |> Map.values() |> Enum.max()
  end

  @doc """
  Insert new marble.

  ## Examples

      iex> Day9.insert_marble(1, [], 0, [])
      {0, [1, 0], []}
      iex> Day9.insert_marble(2, [0], 1, [])
      {0, [2, 0], [1]}
      iex> Day9.insert_marble(3, [0], 2, [1])
      {0, [3, 1, 2, 0], []}
      iex> Day9.insert_marble(4, [1, 2, 0], 3, [])
      {0, [4, 0], [2, 1, 3]}
      iex> Day9.insert_marble(5, [0], 4, [2, 1, 3])
      {0, [5, 2, 4, 0], [1, 3]}
      iex> Day9.insert_marble(23, [5, 21, 10, 20, 2, 19, 9, 18, 4, 17, 8, 16, 0], 22, [11, 1, 12, 6, 13, 3, 14, 7, 15])
      {32, [19, 18, 4, 17, 8, 16, 0], [2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]}

  """
  def insert_marble(marble, behind, current, infront) when rem(marble, 23) == 0 do
    {score, behind, current, infront} = reverse_and_remove_marble(behind, current, infront, 7)

    {score + marble, behind, current, infront}
  end

  def insert_marble(marble, behind, current, infront) do
    # IO.inspect("inser marble")
    move_and_insert_marble(marble, behind, current, infront, 1)
  end

  def move_and_insert_marble(marble, behind, current, infront, 0) do
    # IO.inspect("move and inser marble step 0")
    {0, [current | behind], marble, infront}
  end

  def move_and_insert_marble(marble, behind, current, [], steps) do
    # IO.inspect(behind, label: "move and inser with empty infront marble step #{steps}")
    move_and_insert_marble(marble, [], current, Enum.reverse(behind), steps)
  end

  def move_and_insert_marble(marble, behind, current, [next_marble | infront], steps) do
    # IO.inspect("move and inser marble step #{steps}")
    move_and_insert_marble(marble, [current | behind], next_marble, infront, steps - 1)
  end

  def reverse_and_remove_marble([], current, infront, steps) do
    # IO.inspect("reverse swap with #{steps} left")
    # IO.inspect(infront, label: "infront")
    reverse_and_remove_marble(Enum.reverse(infront), current, [], steps)
  end

  def reverse_and_remove_marble(behind, current, [next_marble | infront], 0) do
    {current, behind, next_marble, infront}
  end

  def reverse_and_remove_marble([next_marble | behind], current, infront, steps) do
    reverse_and_remove_marble(behind, next_marble, [current | infront], steps - 1)
  end
end
