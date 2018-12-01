defmodule Santa do
  def run do
    loop(0)
  end

  defp loop(frequency) do
    case IO.gets("number:\n") |> Integer.parse do
      :error -> frequency
      {input, _} -> loop(frequency + input)
    end
  end
end
