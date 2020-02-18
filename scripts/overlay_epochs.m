%% overlay_epochs.m
% Find all epochs of a certain specification from a single cell,
% then acquire the start, stop, and transition times for adjacent light/dark conditions.
% Plot peristimulus time histograms of spikes for these combined epochs, overlaid
% and centered on the transition time.

%% Load a test data set

% requires cluster to be mounted at /mnt/hasselmogrp
[root, light_on, light_off] = loadLightDarkCell();

% acquire the epoch sets
[epoch_sets] = getEpochs(light_on, light_off, ...
    'MinEpochDuration', 0, ...
    'MaxEpochDuration', Inf, ...
    'Trim', true, ...
    'Verbosity', true);

% acquire the start, transition, and stop times
[epoch_times] = stitchEpochs(epoch_sets);

%% Acquire the overlaid epochs

% produces a cell array of spike counts binned at 5 s
[spike_counts, edges] = overlayEpochs(root, epoch_times(:, [1, 3]), ...
    'BinWidth', 5, ...
    'TimeShift', epoch_times(:, 2), ...
    'Verbosity', true);

%% Pad spike counts

% produces a matrix of binned spike counts, padded by NaNs
[padded_spike_counts, timestamps] = padSpikeCounts(spike_counts, edges, 'both');

% find the mean and standard deviation of the binned spike counts
mean_spike_counts = mean(padded_spike_counts, 1, 'omitnan');
std_spike_counts = std(padded_spike_counts, 0, 1, 'omitnan');

%% Visualize

% mean binned spike count (over all combined epochs)
% error-shaded with standard deviation
figure;

plotlib.shadedErrorBar(timestamps(1:end-1), mean_spike_counts, std_spike_counts);
xlabel('time (s)')
ylabel('spikes/sec')
figlib.pretty('PlotBuffer', 0.1);

% z-scored mean binned spike count (over all combined epochs)
figure;
z_spike_counts = (mean_spike_counts - mean(mean_spike_counts)) ./ std(mean_spike_counts);
plot(timestamps(1:end-1), z_spike_counts);
xlabel('time (s)')
ylabel('a.u.')
figlib.pretty('PlotBuffer', 0.1);

% Visualize PSTH

% cmat = colormaps.linspecer(length(spike_counts));
cmat = lines;

figure;
hold on;

for ii = 1:length(spike_counts)
    histogram('BinEdges', edges{ii}, 'BinCounts', spike_counts{ii}, ...
        'EdgeColor', cmat(ii, :))
end

xlabel('time (s)')
ylabel('spikes/sec')
figlib.pretty('PlotBuffer', 0.1);
