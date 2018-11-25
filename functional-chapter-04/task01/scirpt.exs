defmodule MyList do
  def max([x]), do: x
  def max([x | xs]), do: find_max(xs, x)

  def min([x]), do: x
  def min([x | xs]), do: find_min(xs, x)

  defp find_max([], x), do: x
  defp find_max([y | ys], x) when y >= x, do: find_max(ys, y)
  defp find_max([_ | ys], x), do: find_max(ys, x)

  defp find_min([], x), do: x
  defp find_min([y | ys], x) when y <= x, do: find_min(ys, y)
  defp find_min([_ | ys], x), do: find_min(ys, x)
end

IO.puts MyList.max([4])
IO.puts MyList.max([4, 2, 16, 9, 10])

IO.puts MyList.min([4])
IO.puts MyList.min([4, 2, 16, 9, 10])
