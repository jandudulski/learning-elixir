defmodule Day3 do
  def start(file \\ "input.txt") do
    file
    |> load_input()
    |> List.delete_at(-1)
    |> Enum.map(&parse/1)
    |> Enum.map(&build_matrix/1)
    |> find_uniq()
  end

  defp load_input(file) do
    case File.read(file) do
      {:ok, input} -> String.split(input, "\n")
      _ -> :error
    end
  end

  defp parse(line) do
    with parsed <-
      Regex.named_captures(
        ~r/^#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)$/,
        line
      ),
         id <- parsed["id"],
         {left, _} <- Integer.parse(parsed["left"]),
         {top, _} <- Integer.parse(parsed["top"]),
         {width, _} <- Integer.parse(parsed["width"]),
         {height, _} <- Integer.parse(parsed["height"])
    do
      %{
        id: id,
        l: left,
        t: top,
        w: width,
        h: height,
      }
    end
  end

  defp build_matrix(%{id: id, l: left, h: height, w: width, t: top}) do
    res = List.duplicate(0, left + width) |> List.duplicate(top)

    res =
      res ++
        ((List.duplicate(0, left) ++ List.duplicate(1, width))
        |> List.duplicate(height))

    {id, res}
  end

  defp find_uniq(matrices) do
    find_uniq(matrices, matrices, MapSet.new)
  end
  defp find_uniq([], _, _), do: false
  defp find_uniq([{id, matrix} | rest], matrices, skipped) do
    cond do
      uniq?({id, matrix}, matrices) -> id
      MapSet.member?(skipped, id) -> find_uniq(rest, matrices, skipped)
      true -> find_uniq(rest, matrices, MapSet.put(skipped, id))
    end
  end

  defp uniq?(_, []), do: true
  defp uniq?({id, matrix}, [{id, _} | rest]) do
    uniq?({id, matrix}, rest)
  end
  defp uniq?({id, matrix}, [{_, next} | rest]) do
    with sum <- add_matrices(matrix, next),
         overflows <- Enum.reduce(sum, 0, &find_overflows/2)
    do
      if overflows > 0 do
        false
      else
        uniq?({id, matrix}, rest)
      end
    end
  end

  defp add_matrices(x, y) do
    Enum.zip(x, y)
    |> Enum.map(fn {x, y} -> add_rows(x, y) end)
  end

  defp add_rows([], _), do: []
  defp add_rows(_, []), do: []

  defp add_rows([hx | tx], [hy | ty]) do
    [hx + hy | add_rows(tx, ty)]
  end

  defp find_overflows(row, acc) do
    acc + Enum.count(row, &(&1 > 1))
  end
end
