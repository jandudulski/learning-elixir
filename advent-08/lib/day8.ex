defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """

  @doc """
  Give answer for part 1.

  ## Examples

      iex> Day8.part1("example.txt")
      138

  """
  @spec part1(binary) :: integer
  def part1(file_name) do
    {[], result} =
      file_name
      |> load_file()
      |> sum_of_metadata()

    result
  end

  @doc """
  Give answer for part 2.

  ## Examples

      iex> Day8.part2("example.txt")
      66

  """
  @spec part2(binary) :: integer
  def part2(file_name) do
    {[], result} =
      file_name
      |> load_file()
      |> sum_of_children()

    result
  end

  def load_file(file_name) do
    file_name
    |> File.read!()
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def sum_of_children([]), do: {[], 0}

  def sum_of_children([0, metadata | tail]) do
    tail
    |> Enum.split(metadata)
    |> (fn {head, tail} ->
          {tail, head |> Enum.sum()}
        end).()
  end

  def sum_of_children([children, metadata | tree]) do
    {tail, children} =
      1..children
      |> Enum.reduce({tree, []}, fn _child, {tail, acc} ->
        {tail, sum} = sum_of_children(tail)
        {tail, [sum | acc]}
      end)

    children = Enum.reverse(children)

    tail
    |> Enum.split(metadata)
    |> (fn {head, tail} ->
          subsum =
            head
            |> Enum.reduce(0, fn child_no, acc ->
              acc + Enum.at(children, child_no - 1, 0)
            end)

          {tail, subsum}
        end).()
  end

  def sum_of_metadata([]), do: {[], 0}

  def sum_of_metadata([0, metadata | tail]) do
    tail
    |> Enum.split(metadata)
    |> (fn {head, tail} ->
          {tail, head |> Enum.sum()}
        end).()
  end

  def sum_of_metadata([children, metadata | tree]) do
    {tail, subsum} =
      1..children
      |> Enum.reduce({tree, 0}, fn _child, {tail, acc} ->
        {tail, sum} = sum_of_metadata(tail)
        {tail, acc + sum}
      end)

    tail
    |> Enum.split(metadata)
    |> (fn {head, tail} ->
          {tail, subsum + Enum.sum(head)}
        end).()
  end
end
