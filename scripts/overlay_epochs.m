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

% get the spike times in a cell array of numerical vectors
root.epoch = epoch_times(:, [1, 3]);

%% Acquire spike trains

% % timestamps of the spike train time series centered at the transition time (s)
% timestamps      = cell(size(epoch_times, 1), 1);
% % peristimulus time histogram spike train (ideally, this is close to binary)
% spike_trains    = cell(size(epoch_times, 1), 1);
%
% % get the spike trains
% for ii = 1:length(spike_trains)
%     timestamps{ii} = root.ts{ii} - epoch_times(ii, 2);
%     spike_trains{ii} = getSpikeTrain(root.cel_ts{ii}, root.ts{ii});
% end

%% Acquire peristimulus time histograms

% container for peristimulus time histogram spike count data
spike_counts    = cell(size(epoch_times, 1), 1);
edges           = cell(size(epoch_times, 1), 1);

for ii = 1:length(spike_counts)
    [spike_counts{ii}, edges{ii}] = histcounts(root.cel_ts{ii}, ...
        'BinWidth', 5, ...
        'Normalization', 'countdensity');
    edges{ii} = edges{ii} - epoch_times(ii, 2);
end

% extend spike counts and edges into matrices
[nBins, bin_index] = max(cellfun('length', spike_counts));

for ii = 1:length(spike_counts)
    nPads = (nBins - length(spike_counts{ii})) / 2;
    spike_counts{ii} = padarray(spike_counts{ii}, [0, nPads], NaN, 'both');
    edges{ii} = padarray(edges{ii}, [0, nPads], NaN, 'both');
end

% convert spike counts and bin edges into matrices
padded_spike_counts = cell2mat(spike_counts);
padded_edges = cell2mat(edges);

% find the mean and standard deviation of the spike counts
mean_spike_counts = mean(padded_spike_counts, 1, 'omitnan');
std_spike_counts = std(padded_spike_counts, 0, 1, 'omitnan');

%% Visualize

figure;

plotlib.shadedErrorBar(edges{bin_index}(1:length(mean_spike_counts)), mean_spike_counts, std_spike_counts);
xlabel('time (s)')
ylabel('spikes/sec')
figlib.pretty('PlotBuffer', 0.1);

figure;
z_spike_counts = (mean_spike_counts - mean(mean_spike_counts)) ./ std(mean_spike_counts);
plot(edges{bin_index}(1:length(mean_spike_counts)), z_spike_counts);
xlabel('time (s)')
ylabel('spikes/sec')
figlib.pretty('PlotBuffer', 0.1);

%% Visualize PSTH

% % cmat = colormaps.linspecer(length(spike_counts));
% cmat = lines;
%
% figure;
% hold on;
%
% for ii = 1:length(spike_counts)
%     % histogram('BinEdges', edges{ii}, 'BinCounts', spike_counts{ii}, ...
%     %     'DisplayStyle', 'stairs', ...
%     %     'EdgeColor', cmat(ii, :))
%
%     histogram('BinEdges', edges{ii}, 'BinCounts', spike_counts{ii}, ...
%         'EdgeColor', cmat(ii, :))
% end
%
% xlabel('time (s)')
% ylabel('spikes/sec')
% figlib.pretty('PlotBuffer', 0.1);


%% Visualize

% % plot the raw spike trains
% figure;
% hold on
% cmat = colormaps.linspecer(length(spike_trains));
%
% for ii = 1:length(spike_trains)
%     stairs(timestamps{ii}, spike_trains{ii}, 'Color', cmat(ii, :))
% end
%
% xlabel('time (s)')
% ylabel('spike train')
% figlib.pretty('PlotBuffer', 0.1)
%
% % plot spike trains smoothed with a filter
% this_filter = ones(1000, 1);
% this_filter = this_filter / sum(this_filter);
%
% filtered_spike_trains = cell(size(spike_trains, 1), 1);
% for ii = 1:length(spike_trains)
%     filtered_spike_trains{ii} = NeuralDecoder.encode(spike_trains{ii}, this_filter);
% end
%
% figure;
% hold on
% cmat = colormaps.linspecer(length(spike_trains));
%
% for ii = 1:length(spike_trains)
%     stairs(timestamps{ii}, filtered_spike_trains{ii}, 'Color', cmat(ii, :))
% end
%
% xlabel('time (s)')
% ylabel('firing rate (a.u.)')
% figlib.pretty('PlotBuffer', 0.1)
