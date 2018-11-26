defmodule Sum do
  def up_to(n) do
    up_to_tco(n, 0)
  end

  defp up_to_tco(0, acc), do: acc

  defp up_to_tco(n, acc) do
    up_to_tco(n - 1, acc + n)
  end
end

IO.inspect(Sum.up_to(5))

defmodule Math do
  def sum(list) do
    sum_tco(list, 0)
  end

  defp sum_tco([], acc), do: acc

  defp sum_tco([hd | tl], acc) do
    sum_tco(tl, acc + hd)
  end
end

IO.inspect(Math.sum([10, 5, 15]))

defmodule Sort do
  def merge(left, right) do
    merge_tco(left, right, [])
  end

  defp merge_tco([], right, acc), do: Enum.reverse(acc) ++ right
  defp merge_tco(left, [], acc), do: Enum.reverse(acc) ++ left

  defp merge_tco([left_head | left], right = [right_head | _], acc) when left_head >= right_head do
    merge_tco(left, right, [left_head | acc])
  end

  defp merge_tco(left, [right_head | right], acc) do
    merge_tco(left, right, [right_head | acc])
  end
end

IO.inspect Sort.merge([9, 5], [5, 4, 1])
IO.inspect Sort.merge([2, 2], [3, 1])
IO.inspect Sort.merge(["d", "c"], ["c", "a"])
