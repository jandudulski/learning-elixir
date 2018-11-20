defmodule Rpg do
  @strength 2
  @dexterity 3
  @intelligence 3

  def points_spent(%{dexterity: dexterity, intelligence: intelligence, strength: strength}) do
    dexterity * @dexterity + strength * @strength + intelligence * @intelligence
  end
end

IO.puts(Rpg.points_spent(%{dexterity: 20, strength: 15, intelligence: 18}))
