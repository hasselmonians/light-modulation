# grid-cell-spiking
understanding how and when grid cells spike

Spikes are treated as events with three coordinates
x, y, and t.
x and y are spatial coordinates and t is temporal.

Therefore, a single recording session can be plotted in three-dimensions,
for a single cell.

## Thoughts

We're interested in the distribution of spikes
in regions of spike density.
We can identify regions of spike density by clustering
and then look at distributions of ISIs therein.
