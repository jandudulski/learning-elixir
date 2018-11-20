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

defmodule Cli do
  def start do
    IO.gets("Please provide your salary: \n")
    |> parse
    |> format
    |> IO.puts
  end

  defp parse(input) do
    case Integer.parse(input) do
      :error -> {:error, input}
      {income, _} -> {:ok, income}
    end
  end

  defp format({:ok, income}) do
    "net: #{income - Income.tax(income)}, tax: #{Income.tax(income)}"
  end

  defp format({:error, input}), do: "Invalid input: " <> input
end

Cli.start
