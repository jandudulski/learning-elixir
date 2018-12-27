defmodule Day14 do
  @type recipe :: non_neg_integer()

  @doc """
  Answer to part 1.

  ## Examples

      iex> Day14.part1(9)
      "5158916779"
      iex> Day14.part1(5)
      "0124515891"
      iex> Day14.part1(18)
      "9251071085"
      iex> Day14.part1(2018)
      "5941429882"

  """
  def part1(puzzle_input \\ 681_901) do
    {scores, elf1, elf2} = init()

    unfold_stream(scores, elf1, elf2)
    |> Stream.drop(puzzle_input)
    |> Enum.take(10)
    |> Enum.join("")
  end

  @doc """
  Answer to part 2.

  ## Examples

      iex> Day14.part2("51589")
      9
      iex> Day14.part2("01245")
      5
      iex> Day14.part2("92510")
      18
      iex> Day14.part2("59414")
      2018

  """
  def part2(puzzle_input \\ "681901") do
    {scores, elf1, elf2} = init()

    puzzle_input =
      puzzle_input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    puzzle_count = puzzle_input |> Enum.count()

    unfold_stream(scores, elf1, elf2)
    |> Stream.chunk_every(puzzle_count, 1)
    |> Stream.with_index()
    |> Enum.find_value(fn {chunk, index} ->
      chunk == puzzle_input && index
    end)
  end

  defp init do
    elf1 = 0
    elf2 = 1

    scores = :array.new()
    scores = :array.set(elf1, 3, scores)
    scores = :array.set(elf2, 7, scores)

    {scores, elf1, elf2}
  end

  defp unfold_stream(scores, elf1, elf2) do
    Stream.unfold({scores, elf1, elf2, 0}, fn {scores, elf1, elf2, index} ->
      elf1_score = :array.get(elf1, scores)
      elf2_score = :array.get(elf2, scores)

      scores =
        combine_recipes(elf1_score, elf2_score)
        |> Enum.reduce(scores, fn recipe, scores ->
          :array.set(:array.size(scores), recipe, scores)
        end)

      elf1 = Integer.mod(elf1 + elf1_score + 1, :array.size(scores))
      elf2 = Integer.mod(elf2 + elf2_score + 1, :array.size(scores))

      {:array.get(index, scores), {scores, elf1, elf2, index + 1}}
    end)
  end

  @spec combine_recipes(recipe, recipe) :: [recipe]
  defp combine_recipes(left, right) do
    (left + right) |> Integer.digits()
  end
end
