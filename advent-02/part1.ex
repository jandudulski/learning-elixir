defmodule Checksum do
  def checksum(file \\ "input.txt") do
    case File.read(file) do
      {:ok, input} -> String.split(input) |> Enum.map(&checksum_letters/1) |> Enum.reduce({0, 0}, fn {x, y}, {acc_x, acc_y} ->
        {x + acc_x, y + acc_y}
      end)
      _ -> :error
    end
  end

  def checksum_letters(word) do
    split = letters(word)

    {Enum.member?(split, 2) && 1 || 0, Enum.member?(split, 3) && 1 || 0}
  end

  def letters(word) do
    word
    |> String.codepoints
    |> Enum.reduce(%{}, fn letter, acc ->
      if Map.has_key?(acc, letter) do
        Map.put(acc, letter, acc[letter] + 1)
      else
        Map.put(acc, letter, 1)
      end
    end)
    |> Map.values
  end
end
