defmodule Income do
  def tax(income) do
    cond do
      income <= 2000 -> 0
      income <= 3000 -> 0.05 * income
      income <= 6000 -> 0.1 * income
      true -> 0.15 * income
    end
  end
end

IO.puts Income.tax(1000)
IO.puts Income.tax(2500)
IO.puts Income.tax(4000)
IO.puts Income.tax(8000)
