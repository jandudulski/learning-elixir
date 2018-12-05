defmodule Day5 do
  def reduce_polymer(input) when is_binary(input) do
    input
    |> String.trim()
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

      test "reduce_polymer" do
        assert "example.txt" |> File.read!() |> reduce_polymer() == 10
      end
    end

  [input_file] ->
    input_file
    |> File.read!()
    |> Day5.reduce_polymer()
    |> IO.puts()
end
