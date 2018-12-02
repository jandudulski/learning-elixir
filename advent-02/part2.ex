defmodule Checksum do
  def checksum(file \\ "input.txt") do
    file
    |> load_input()
    |> Enum.sort()
    |> Enum.chunk_every(2, 1)
    |> Enum.find(&check_diff/1)
    |> (fn [left, right] -> String.myers_difference(left, right) end).()
    |> Keyword.get_values(:eq)
    |> Enum.join("")
  end

  defp load_input(file) do
    case File.read(file) do
      {:ok, input} -> String.split(input)
      _ -> :error
    end
  end

  defp check_diff([left, right]) do
    diff = String.myers_difference(left, right)
    keys = Keyword.keys(diff)

    Enum.count(keys, &(&1 == :del)) == 1
    && Enum.count(keys, &(&1 == :ins)) == 1
    && String.length(diff[:del]) == 1
    && String.length(diff[:ins]) == 1
  end
end
