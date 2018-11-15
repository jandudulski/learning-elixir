Create a module called `MatchstickFactory` and a function called `boxes/1`. The function will calculate the number of boxes necessary to accommodate some matchsticks. It returns a map with the number of boxes necessary for each type of box. The factory has three types of boxes: the big ones hold fifty matchsticks, the medium ones hold twenty, and the small ones hold five. The boxes can't have fewer matchsticks that they can hold; they must be full. The returning map should contain the remaining matchsticks. It should work like this:

```
MatchstickFactory.boxes(98)
# %{big: 1, medium: 2, remaining_matchsticks: 3, small: 1}
MatchstickFactory.boxes(39)
# %{big: 0, medium: 1, remaining_matchsticks: 4, small: 3}
```

Tip: You'll need to use the `rem/2` and `div/2` functions.
