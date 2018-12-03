defmodule Day3 do
  def start(file \\ "input.txt") do
    file
    |> load_input()
    |> List.delete_at(-1)
    |> Enum.map(&parse/1)
    |> build_matrices
    |> Enum.reduce(&add_matrices/2)
    |> Enum.reduce(0, &find_overflows/2)
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
         {left, _} <- Integer.parse(parsed["left"]),
         {top, _} <- Integer.parse(parsed["top"]),
         {width, _} <- Integer.parse(parsed["width"]),
         {height, _} <- Integer.parse(parsed["height"]),
         board_width <- left + width,
         board_height <- top + height do
      %{
        l: left,
        t: top,
        w: width,
        h: height,
        bw: board_width,
        bh: board_height
      }
    end
  end

  defp add_matrices(x, y) do
    Enum.zip(x, y) |> Enum.map(fn {x, y} -> add_rows(x, y) end)
  end

  defp add_rows([], []), do: []

  defp add_rows([hx | tx], [hy | ty]) do
    [hx + hy | add_rows(tx, ty)]
  end

  defp build_matrices(claims) do
    with widest_claim <- Enum.max_by(claims, & &1.bw),
         highest_claim <- Enum.max_by(claims, & &1.bh),
         max_width <- widest_claim.bw,
         max_height <- highest_claim.bh do
      claims |> Enum.map(&build_matrix(&1, max_width, max_height))
    end
  end

  defp build_matrix(%{l: left, h: height, w: width, t: top}, board_width, board_height) do
    with right <- board_width - width - left,
         bottom <- board_height - top - height do
      res = List.duplicate(0, board_width) |> List.duplicate(top)

      res =
        res ++
          ((List.duplicate(0, left) ++ List.duplicate(1, width) ++ List.duplicate(0, right))
           |> List.duplicate(height))

      res = res ++ (List.duplicate(0, board_width) |> List.duplicate(bottom))

      res
    end
  end

  defp find_overflows(row, acc) do
    acc + Enum.count(row, &(&1 > 1))
  end
end
