defmodule Sort do
  def descending([]), do: []
  def descending([a]), do: [a]
  def descending(list) do
    half_size = list |> Enum.count |> div(2)
    {left, right} = Enum.split(list, half_size)
    merge(descending(left), descending(right))
  end

  defp merge([], right), do: right
  defp merge(left, []), do: left
  defp merge(left = [hl | tl], right = [hr | tr]) do
    cond do
      hl >= hr -> [hl | merge(tl, right)]
      true -> [hr | merge(left, tr)]
    end
  end
end

IO.inspect Sort.descending([9, 5, 1, 5, 4])
IO.inspect Sort.descending([2, 2, 3, 1])
IO.inspect Sort.descending(["c", "d", "a", "c"])
