defmodule Day10 do
  import NimbleParsec

  @type position :: {integer, integer}
  @type velocity :: {integer, integer}

  tupple =
    ignore(string("<"))
    |> ignore(repeat(string(" ")))
    |> choice([
      string("-"),
      string("")
    ])
    |> integer(min: 1)
    |> ignore(string(","))
    |> ignore(repeat(string(" ")))
    |> choice([
      string("-"),
      string("")
    ])
    |> integer(min: 1)
    |> ignore(string(">"))

  defparsecp(
    :parsec_line,
    ignore(string("position="))
    |> concat(tupple)
    |> ignore(string(" velocity="))
    |> concat(tupple)
  )

  @doc """
  Part 1.
  """
  def part1(file_name \\ "example.txt") do
    with points <- parse_points(file_name) do
      seconds = 0..150_000 |> Enum.min_by(&board_size_after(points, &1))

      render_after(points, seconds)
    end
  end

  @doc """
  Part 2.
  """
  def part2(file_name \\ "example.txt") do
    with points <- parse_points(file_name) do
      0..150_000 |> Enum.min_by(&board_size_after(points, &1))
    end
  end

  def parse_points(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
  end

  def board_size_after(points, seconds) do
    {max_x, max_y} =
      points
      |> Enum.map(&move(&1, seconds))
      |> normalize()
      |> boundaries()

    max_x * max_y
  end

  def render_after(points, seconds) do
    points
    |> Enum.map(&move(&1, seconds))
    |> generate_board()
    |> render()
  end

  def render(board) do
    board
    |> Enum.each(fn axis ->
      Enum.join(axis, "") |> IO.puts()
    end)
  end

  def generate_board(points) do
    with points <- normalize(points),
         {max_x, max_y} <- boundaries(points),
         points <- MapSet.new(points) do
      Enum.map(0..max_y, fn y ->
        Enum.map(0..max_x, fn x ->
          if {x, y} in points do
            "#"
          else
            "."
          end
        end)
      end)
    end
  end

  @doc """
  Find board boundaries.

  ### Examples

      iex> Day10.boundaries([{5, 2}, {3, 1}, {1, 3}])
      {5, 3}

  """
  @spec boundaries([position]) :: position
  def boundaries(points) do
    {max_x, _} = points |> Enum.max_by(&elem(&1, 0))
    {_, max_y} = points |> Enum.max_by(&elem(&1, 1))

    {max_x, max_y}
  end

  @doc """
  Find normalization velocity.

  ### Examples

      iex> Day10.normalize([{-2, 1}, {3, -2}])
      [{0, 3}, {5, 0}]
      iex> Day10.normalize([{2, 1}, {3, 2}])
      [{2, 1}, {3, 2}]

  """
  @spec normalize([position]) :: [position]
  def normalize(points) do
    with {min_x, _} <- points |> Enum.min_by(&elem(&1, 0)),
         {_, min_y} <- points |> Enum.min_by(&elem(&1, 1)),
         normalized_x <- min_x |> min(0) |> abs(),
         normalized_y <- min_y |> min(0) |> abs(),
         velocity <- {normalized_x, normalized_y} do
      points |> Enum.map(&move({&1, velocity}, 1))
    end
  end

  @doc """
  Move from position with velocity.

  ## Examples

      iex> Day10.move({{-2, 3}, {1, -2}}, 1)
      {-1, 1}
      iex> Day10.move({{-2, 3}, {1, -2}}, 0)
      {-2, 3}
      iex> Day10.move({{-2, 3}, {1, -2}}, 2)
      {0, -1}

  """
  @spec move({position, velocity}, integer) :: position
  def move({{pos_x, pos_y}, {vel_x, vel_y}}, times) do
    {pos_x + vel_x * times, pos_y + vel_y * times}
  end

  @doc """
  Parse line from input

  ## Examples

      iex> Day10.parse("position=<-9,  1> velocity=< 0, -2>")
      {{-9, 1}, {0, -2}}
      iex> Day10.parse("position=< 2, -4> velocity=<-2,  20>")
      {{2, -4}, {-2, 20}}
      iex> Day10.parse("position=<1, 3> velocity=<2, -1>")
      {{1, 3}, {2, -1}}

  """
  @spec parse(binary) :: {position, velocity}
  def parse(line) when is_binary(line) do
    {:ok, result, _, _, _, _} = parsec_line(line)

    [pos_x, pos_y, vel_x, vel_y] =
      result
      |> Enum.chunk_every(2)
      |> Enum.map(fn
        ["-", num] -> -num
        [_, num] -> num
      end)

    {{pos_x, pos_y}, {vel_x, vel_y}}
  end
end
