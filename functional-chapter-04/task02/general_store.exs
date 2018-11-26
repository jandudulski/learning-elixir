defmodule GeneralStore do
  def test_data do
    [
      %{title: "Longsword", price: 50, magic: false},
      %{title: "Healing Potion", price: 60, magic: true},
      %{title: "Rope", price: 10, magic: false},
      %{title: "Dragon's Spear", price: 100, magic: true},
    ]
  end

  def filter_items([], _), do: []
  def filter_items([item = %{magic: magic} | rest], magic: magic) do
    [item | filter_items(rest, magic: magic)]
  end
  def filter_items([_ | rest], opts) do
    filter_items(rest, opts)
  end
end

IO.inspect GeneralStore.filter_items(GeneralStore.test_data, magic: true)
IO.inspect GeneralStore.filter_items(GeneralStore.test_data, magic: false)
