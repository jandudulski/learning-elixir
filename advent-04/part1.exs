defmodule Day4 do
  def find_guard(file_stream) do
    file_stream
    |> Stream.map(&parse_line/1)
    |> Enum.sort(&compare_times/2)
    |> Enum.reduce({"Guard 0", "00:00:00", %{}}, fn line, {guard, time, acc} ->
      case line.label do
        "falls asleep" ->
          {guard, line.time, acc}
        "wakes up" ->
          acc = acc |> Map.update!(guard, &(time_range(time, line.time) ++ &1))
          {guard, line.time, acc}
        _ ->
          guard = line.label |> parse_guard()
          {guard, line.time, Map.put_new(acc, guard, [])}
      end
    end)
    |> (fn {_, _, v} -> v end).()
    |> find_sleepyhead()
    |> find_asleep()
    |> answer()
  end

  defp parse_line(line) do
    with parsed <- Regex.named_captures(~r/^\[(?<date_time>.+)] (?<label>.+)$/, line),
         {:ok, date_time} <- NaiveDateTime.from_iso8601(parsed["date_time"] <> ":00"),
         time <- NaiveDateTime.to_time(date_time),
         label <- parsed["label"]
    do
      %{date_time: date_time, time: time, label: label}
    end
  end

  defp parse_guard(line) do
    line
    |> String.replace_prefix("Guard #", "")
    |> String.replace_suffix(" begins shift", "")
    |> String.to_integer()
  end

  defp compare_times(left, right) do
    case NaiveDateTime.compare(left.date_time, right.date_time) do
      :lt -> true
      _ -> false
    end
  end

  defp time_range(start_time, end_time) do
    diff = Time.diff(end_time, start_time) - 60
    for i <- 0..diff, rem(i, 60) == 0, do: Time.add(start_time, i)
  end

  defp find_sleepyhead(candidates) do
    candidates
    |> Enum.max_by(fn {_, values} -> Enum.count(values) end)
  end

  defp find_asleep({guard, times}) do
    Enum.reduce(times, %{}, fn time, acc -> Map.update(acc, time, 1, &(&1 + 1)) end)
    |> Enum.max_by(fn {_time, val} -> val end)
    |> (fn {time, _counter} -> {guard, time} end).()
  end

  defp answer({guard, time}) do
    time
    |> Time.diff(~T[00:00:00])
    |> div(60)
    |> (&(guard * &1)).()
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day4Test do
      use ExUnit.Case

      import Day4

      test "find_guard" do
        {:ok, io} =
          StringIO.open("""
          [1518-11-01 00:00] Guard #10 begins shift
          [1518-11-01 00:05] falls asleep
          [1518-11-01 00:25] wakes up
          [1518-11-01 00:30] falls asleep
          [1518-11-01 00:55] wakes up
          [1518-11-05 00:03] Guard #99 begins shift
          [1518-11-05 00:45] falls asleep
          [1518-11-05 00:55] wakes up
          [1518-11-03 00:05] Guard #10 begins shift
          [1518-11-03 00:24] falls asleep
          [1518-11-03 00:29] wakes up
          [1518-11-04 00:02] Guard #99 begins shift
          [1518-11-04 00:36] falls asleep
          [1518-11-04 00:46] wakes up
          [1518-11-01 23:58] Guard #99 begins shift
          [1518-11-02 00:40] falls asleep
          [1518-11-02 00:50] wakes up
          """)

        assert find_guard(IO.stream(io, :line)) == 240
      end
    end

  [input_file] ->
    input_file
    |> File.stream!()
    |> Day4.find_guard()
    |> IO.puts()
end
