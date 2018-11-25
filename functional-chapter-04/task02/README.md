In the section Transforming Lists, we traveled to a fantasy world and enchanted some items. Create a new module called `GeneralStore` where you can create a function that filters based on whether the products are magical. You can use the same test data from `EnchanterShop`:

```
GeneralStore.filter_items(GeneralStore.test_data, magic: true)
# => [%{title: "Healing Potion", price: 60, magic: true},
#     %{title: "Dragon's Spear", price: 100, magic: true}]
GeneralStore.filter_items(GeneralStore.test_data, magic: false)
# => [%{title: "Longsword", price: 50, magic: false},
#     %{title: "Rope", price: 10, magic: false}]
```
