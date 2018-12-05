defmodule Day5 do
  def shortest_polymer_size(input) when is_binary(input) do
    ?a..?z
    |> Enum.map(&reduce_polymer_without(input, &1))
    |> Enum.min()
  end

  def reduce_polymer_without(input, codepoint) do
    with {:ok, regex} <- Regex.compile(<<codepoint>>, "i")
    do
      input |> String.replace(regex, "") |> reduce_polymer()
    end
  end

  def reduce_polymer(input) when is_binary(input) do
    input
    |> reduce_polymer([])
    |> Enum.count()
  end

  defp reduce_polymer(<<first, second, rest::binary>>, []) do
    case abs(first - second) do
      32 -> reduce_polymer(rest, [])
      _ -> reduce_polymer(<<second>> <> rest, [<<first>>])
    end
  end

  defp reduce_polymer(<<first, second, rest::binary>>, output = [last | tail]) do
    case abs(first - second) do
      32 -> reduce_polymer(last <> rest, tail)
      _ -> reduce_polymer(<<second>> <> rest, [<<first>> | output])
    end
  end

  defp reduce_polymer(<<letter>>, output), do: [<<letter>> | output]

  defp reduce_polymer(<<>>, output), do: output
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule Day4Test do
      use ExUnit.Case

      import Day5

      test "shortest_polymer_size" do
        assert "example.txt" |> File.read!() |> String.trim() |> shortest_polymer_size() == 4
      end
    end

  [input_file] ->
    input_file
    |> File.read!()
    |> String.trim()
    |> Day5.shortest_polymer_size()
    |> IO.puts()
end
