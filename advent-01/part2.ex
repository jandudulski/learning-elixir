defmodule Santa do
  def run do
    IO.puts("input:")
    input([]) |> loop
  end

  defp input(list) do
    case IO.gets("\n") |> Integer.parse() do
      :error -> Enum.reverse(list)
      {input, _} -> input([input | list])
    end
  end

  defp loop(list) do
    frequency(list, 0, [], %{})
  end

  defp frequency([], current, processed, frequencies) do
    frequency(Enum.reverse(processed), current, [], frequencies)
  end

  defp frequency([head | rest], current, processed, frequencies) do
    current = current + head

    case frequencies[current] do
      1 -> current
      _ -> frequency(rest, current, [head | processed], Map.put(frequencies, current, 1))
    end
  end
end
