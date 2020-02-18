%% Average over epochs to get the mean firing rate over epochs
% from binned spike counts

%% Load the data table
% requires a 'spike_counts' variable of padded spike counts

load('~/code/grid-cell-spiking/data/data-Holger-LightDark2.mat');

%% Collect the mean binned spike counts

mean_binned_spike_counts = cell(height(data_table), 1);

for ii = 1:height(data_table)
    mean_binned_spike_counts{ii} = averageOverNaNs(data_table.spike_counts{ii});
end

%% Pad spike counts and compress into a matrix

[padded_mean_binned_spike_counts, timestamps] = ...
    padSpikeCounts(mean_binned_spike_counts, data_table.timestamps, 'both');

%% Average over padded mean binned spike counts

[these_spike_counts, these_errors] = averageOverNaNs(padded_mean_binned_spike_counts);

%% Visualize

% mean binned spike count (over all combined epochs & cells)
% error-shaded with standard deviation
figure;

plotlib.shadedErrorBar(timestamps(1:end-1), these_spike_counts, these_errors);
xlabel('time (s)')
ylabel('spikes/sec')
title('mean binned spike counts (over all cells)')
figlib.pretty('PlotBuffer', 0.1);

% z-scored mean binned spike count (over all combined epochs & cells)
figure;
z_spike_counts = (these_spike_counts - mean(these_spike_counts)) ./ these_errors;
plot(timestamps(1:end-1), z_spike_counts);
xlabel('time (s)')
ylabel('a.u.')
title('z-scored mean binned spike counts (over all cells)')
figlib.pretty('PlotBuffer', 0.1);
