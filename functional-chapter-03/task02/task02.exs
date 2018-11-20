defmodule TicTacToe do
  def winner({a, a, a, _, _, _, _, _, _}) do
    {:winner, a}
  end

  def winner({_, _, _, a, a, a, _, _, _}) do
    {:winner, a}
  end

  def winner({_, _, _, _, _, _, a, a, a}) do
    {:winner, a}
  end

  def winner({a, _, _, a, _, _, a, _, _}) do
    {:winner, a}
  end

  def winner({_, a, _, _, a, _, _, a, _}) do
    {:winner, a}
  end

  def winner({_, _, a, _, _, a, _, _, a}) do
    {:winner, a}
  end

  def winner({a, _, _, _, a, _, _, _, a}) do
    {:winner, a}
  end

  def winner({_, _, a, _, a, _, a, _, _}) do
    {:winner, a}
  end

  def winner(_) do
    :no_winner
  end
end

TicTacToe.winner({
  :x, :o, :x,
  :o, :x, :o,
  :o, :o, :x
}) |> IO.inspect

TicTacToe.winner({
  :x, :o, :x,
  :o, :x, :o,
  :o, :x, :o
}) |> IO.inspect
