defmodule Day7 do
  import NimbleParsec

  @time_diff 4

  @type step :: char

  @moduledoc """
  Documentation for Day7.
  """

  defparsecp(
    :parsec_steps,
    ignore(string("Step "))
    |> ascii_char([?A..?Z])
    |> ignore(string(" must be finished before step "))
    |> ascii_char([?A..?Z])
    |> ignore(string(" can begin."))
  )

  @doc """
  Find word for part 1.

  ## Examples

      iex> Day7.part1("example.txt")
      "CABDFE"

  """
  @spec part1(binary) :: binary
  def part1(file_name) do
    with graph <- file_name |> load_and_parse_input() |> build_graph(),
    roots <- find_roots(graph) do
      graph
      |> traverse_graph([], roots)
      |> Enum.reverse()
      |> List.to_string()
    end
  end

  @doc """
  Find word for part 2.

  ## Examples

      iex> Day7.part2("example.txt", 2)
      258

  """
  @spec part2(binary, integer) :: integer
  def part2(file_name, workers) do
    with graph <- file_name |> load_and_parse_input() |> build_graph(),
    roots <- find_roots(graph) do
      graph
      |> traverse_graph_with_workers([], roots, 0, workers, [])
    end
  end

  @doc """
  Find starting points in graph.

  ## Examples

      iex> Day7.find_roots(%{?A => 'BD', ?B => 'E', ?C => 'AF', ?D => 'E', ?F => 'E'})
      [67]

  """
  @spec find_roots(map) :: [step]
  def find_roots(graph) do
    with candidates <- Map.keys(graph) do
      candidates
      |> Enum.filter(fn letter ->
        graph
        |> Enum.all?(fn {_, v} -> letter not in v end)
      end)
    end
    |> Enum.sort()
  end

  def traverse_graph_with_workers(graph, _, [], clock, _, []) when graph == %{} do
    clock - 1
  end

  def traverse_graph_with_workers(graph, acc, next_steps, clock, available_workers, workers) do
    {completed, workers} = progress_work(workers)
    acc = completed ++ acc
    available_workers = available_workers + Enum.count(completed)
    {graph, next_steps} = fetch_next_steps(graph, completed, next_steps)
    {workers, available_workers, next_steps} = schedule_work(graph, workers, acc, available_workers, next_steps)
    clock = clock + 1

    traverse_graph_with_workers(graph, acc, next_steps, clock, available_workers, workers)
  end

  def fetch_next_steps(graph, completed, next_steps) do
    completed
    |> Enum.reduce({graph, next_steps}, fn step, {graph, next_steps} ->
      next_steps = Map.get(graph, step, []) ++ next_steps
      graph = Map.delete(graph, step)

      {graph, next_steps}
    end)
    |> (fn {graph, next_steps} -> {graph, Enum.sort(next_steps)} end).()
  end

  def schedule_work(_, workers, _, 0, next_steps) do
    {workers, 0, next_steps}
  end

  def schedule_work(_, workers, _, available_workers, []) do
    {workers, available_workers, []}
  end

  def schedule_work(graph, workers, completed_steps, available_workers, [step | next_steps]) do
    with future_steps <- Enum.flat_map(graph, fn {_, v} -> v end) do
      if step in completed_steps or step in future_steps do
        schedule_work(graph, workers, completed_steps, available_workers, next_steps)
      else
        workers = [{step, 1} | workers]

        schedule_work(graph, workers, completed_steps, available_workers - 1, next_steps)
      end
    end
  end

  @doc """
  Ticks the clock and moves work forward.

  ## Examples

      iex> Day7.progress_work([{?C, 1}, {?B, 2}])
      {[?B], [{?C, 2}]}

  """
  def progress_work(workers) do
    workers
    |> Enum.reduce({[], []}, fn {letter, counter}, {completed, processing} ->
      if letter - @time_diff - counter == 0 do
        {[letter | completed], processing}
      else
        {completed, [{letter, counter + 1} | processing]}
      end
    end)
  end

  def traverse_graph(graph, acc, [last]) when graph == %{} do
    if last in acc, do: acc, else: [last | acc]
  end

  def traverse_graph(graph, acc, [step | next_steps]) do
    with future_steps <- Enum.flat_map(graph, fn {_, v} -> v end) do
      if step in future_steps or step in acc do
          traverse_graph(graph, acc, next_steps)
      else
        next_steps =
          Map.get(graph, step, []) ++ next_steps
          |> Enum.sort()

        Map.delete(graph, step)
        |> traverse_graph([step | acc], next_steps)
      end
    end
  end

  @spec load_and_parse_input(binary) :: [{integer, integer}]
  def load_and_parse_input(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_step/1)
  end

  @doc """
  Build graph as adjacency list.

  ## Examples

      iex> Day7.build_graph([
      ...>   {67, 65},
      ...>   {67, 70},
      ...> ])
      %{ 67 => [65, 70] }

  """
  @spec build_graph([{integer, integer}]) :: map
  def build_graph(list) do
    list
    |> Enum.reduce(%{}, fn {step_before, step_after}, graph ->
      Map.update(graph, step_before, [step_after], &[step_after | &1])
    end)
    |> Enum.into(%{}, fn {k, v} -> {k, Enum.sort(v)} end)
  end

  @doc """
  Parses single line and returns step names.

  ## Examples

      iex> Day7.parse_step("Step X must be finished before step Q can begin.")
      {88, 81}

  """
  @spec parse_step(binary) :: {step, step}
  def parse_step(line) when is_binary(line) do
    {:ok, [left, right], _, _, _, _} = parsec_steps(line)

    {left, right}
  end
end
