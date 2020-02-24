# Light/Dark Modulation

#### The experiment

A mouse freely explores a 1-meter-square arena in conditions of normal light
and total darkness.
Neural recordings are taken and the start and stop times of the light/dark epochs
are also recorded.

#### The goal

Statistically and graphically analysis whether cells are modulated by illumination condition.

This package assumes that the data exist as `CMBHOME.Session` objects
(see [CMBHOME](https://github.com/hasselmonians/CMBHOME)).
Here, we use the [RatCatcher](https://github.com/hasselmonians/RatCatcher) framework
to process the data.

## Installation

1. Download this repository.
2. Download [RatCatcher](https://github.com/hasselmonians/RatCatcher).
3. Download [CMBHOME](https://github.com/hasselmonians/CMBHOME).
4. Download [mtools](https://github.com/sg-s/srinivas.gs_mtools).
5. Add them to your MATLAB path.

## Light/Dark modulation

This analysis is split into two steps.

In the first step, cells are identified which are responsive to illumination level
(that is, they are modulated by light).
This is determined by comparing the mean firing rate between epochs
for adjacent light/dark epoch pairs.
Statistical significance is determined using paired t-tests.

In the second step, the resultant data set from the first step is filtered
for significance by p-value and for direction of modulation.
Positively-modulated cells are defined as cells which fire statistically significantly more frequently on average in dark conditions.
Negatively-modulated cells are defined as cells which fire statistically significantly more frequently on average in light conditions.
Paired light/dark epochs are concatenated and spike times are binned.
Since the epochs may be of varying length, spike count vectors are NaN-padded.

The analysis can be performed light-epoch first (LightDark) and dark-epoch first (DarkLight).

## Workflow

### First-Pass

In the first step, cells are identified which are modulated by illumination level.

> The following steps are recorded in
> `light-dark/scripts/runHolgerDataFirstPass.m`.

Decide on the correct protocol (light-epoch first or dark-epoch first).
Then create the `RatCatcher` object `r`.

```matlab
protocol = 'LightDark';
% protocol = 'DarkLight';
r = getFirstPassRatCatcher(protocol);
```

Check the `RatCatcher` object to make sure that it is what you want.
The `getFirstPassRatCatcher` function has hardcoded paths and other shortcuts
(it assumes that your high-performance computing cluster is mounted at a certain location, etc.).

Then, generate the cluster files:

```matlab
r = r.batchify();
```

and submit the jobs to the cluster, e.g. using `qsub`.
See [here](https://github.com/hasselmonians/RatCatcher#a-real-usage-example) for an example.

Once the cluster jobs have run,
you can gather them normally,

```matlab
data_table = r.gather();
data_table = r.stitch(data_table);
```

and save them normally.

### Second-Pass

The second-pass identifies modulated cells by p-value and modulation type
and then collects binned spike times over all epochs in a NaN-padded matrix
and over all cells in a table.

> The following steps are recorded in
> `light-dark/scripts/runHolgerDataSecondPass.m`.

The workflow for the second-pass is much like the first.
For convenience, filtering of the data table has been written into several utility functions.
You can use `getSecondPassRatCatcher` to set up a `RatCatcher` object
and include analysis over only cells which exhibit statistically significant modulation.
Four options are built-in:

1. p = 0.01, modulation = positive
2. p = 0.05, modulation = positive
3. p = 0.01, modulation = negative
4. p = 0.05, modulation = negative

```matlab
protocol = 'LightDark'; % or 'DarkLight';
r = getSecondPassRatCatcher(protocol, this_index);
```

Then, batch the jobs

```matlab
r = r.batchify();
```

and submit the jobs to the cluster, e.g. using `qsub`.
See [here](https://github.com/hasselmonians/RatCatcher#a-real-usage-example) for an example.

The jobs cannot be gathered normally.
Instead, use the following syntax:

```matlab
data_table = LightDark2.gather(r);
data_table = r.stitch(data_table);
```

## Post-processing

Working with NaN-padded matrices takes special care
as NaNs have a tendency to pollute computations.

For a single cell,
you can use the `averageOverNaNs` function
to get the mean and standard deviation,
accounting for the varying durations of epochs.

```matlab
[vec_mean, vec_std] = averageOverNaNs(padded_spike_counts);
```

To average over an entire population of cells,
use the `averageOverEpochsCells` function.
Since cells can have differing basal firing rates,
each cell's binned spike count averaged over epochs is z-scored first.

```matlab
[zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table, bin_size)
```

> The script `light-dark/scripts/make_figures.m`
> includes code for sample plots.

## Optogenetic Modulation

work-in-progress
