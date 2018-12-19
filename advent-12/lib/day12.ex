defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  @doc """
  Answer to part 1.

  ## Examples

      iex> Day12.part1("example.txt")
      325

  """
  def part1(file_name) when is_binary(file_name) do
    {initial_state, notes} = load_input(file_name)

    {shift, state} = produce_generation(initial_state, notes, 20)

    -shift..(Enum.count(state) - shift)
    |> Enum.zip(state)
    |> Enum.reduce(0, fn
      {_, "."}, acc -> acc
      {value, "#"}, acc -> value + acc
    end)
  end

  @doc """
  Answer to part 2.
  """
  def part2(file_name) when is_binary(file_name) do
    {initial_state, notes} = load_input(file_name)

    {shift, state} = produce_generation(initial_state, notes, 50_000_000_000)

    -shift..(Enum.count(state) - shift)
    |> Enum.zip(state)
    |> Enum.reduce(0, fn
      {_, "."}, acc -> acc
      {value, "#"}, acc -> value + acc
    end)
  end

  def produce_generation(initial_state, notes, generation) do
    1..generation
    |> Enum.reduce_while({0, initial_state}, fn step, {previous_shift, previous_state} ->
      {shift, state} = apply_notes(previous_state, notes)

      shift = shift + previous_shift - 2

      if previous_state == state do
        shift_per_state = shift - previous_shift
        shift = shift + shift_per_state * (generation - step)

        {:halt, {shift, state}}
      else
        {:cont, {shift, state}}
      end
    end)
  end

  def apply_notes(state, notes) do
    {shift, state} = shift_state(state)

    state = generate_state(state, notes)

    {shift, state}
  end

  def generate_state([a, b, c, d, e | tail], notes) do
    [Map.get(notes, [a, b, c, d, e], ".") | generate_state([b, c, d, e | tail], notes)]
  end

  def generate_state([a, b, c, d], notes) do
    [
      Map.get(notes, [a, b, c, d, "."], "."),
      Map.get(notes, [b, c, d, ".", "."], "."),
      Map.get(notes, [c, d, ".", ".", "."], ".")
    ]
  end

  @doc """
  Add empty spaces on the edges.

  ## Examples

      iex> Day12.shift_state(["#", ".", ".", ".", ".", "#", "#", "#"])
      {5, [".", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", "#", "#"]}

  """
  def shift_state(state = ["#" | _]) do
    {3, [".", ".", "." | state]}
  end

  def shift_state(state = [".", "#" | _]) do
    {2, [".", "." | state]}
  end

  def shift_state(state = [".", ".", "#" | _]) do
    {1, ["." | state]}
  end

  def shift_state(state) do
    {0, state}
  end

  def load_input(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> (fn [initial_state | notes] ->
          initial_state =
            initial_state |> String.replace_prefix("initial state: ", "") |> String.graphemes()

          {initial_state, parse_notes(notes)}
        end).()
  end

  @doc """
  Parse list of notes into hash note => result.

  ## Examples

      iex> Day12.parse_notes(["...## => #", "..#.. => ."])
      %{[".", ".", ".", "#", "#"] => "#", [".", ".", "#", ".", "."] => "."}

  """
  def parse_notes(notes) do
    notes
    |> Enum.reduce(%{}, fn note, acc ->
      [note, result] = String.split(note, " => ")
      Map.put(acc, String.graphemes(note), result)
    end)
  end
end
