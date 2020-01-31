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

## Other Thoughts
For comparing the light/dark conditions,
we should make sure to only compare adjacent trials to each other,
since there is no guarantee that the firing rate is stationary.
Furthermore, we should take care to look at both the mean firing rate
and the firing rate during transitional periods.

The firing rate will need to be approximated from kernel smoothing over the spike train.
The best way to do this is to pick an arbitrary kernel and bandwidth (the traditional method),
or apply the bandwidth optimization procedure.

We should then be able to fit a curve to the firing rate,
and within each epoch, fit a decaying exponential to it,
to determine the slope of the decay (the time constant parameter).
