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

%% Acquire spike trains

% timestamps of the spike train time series centered at the transition time (s)
timestamps      = cell(size(epoch_times, 1), 1);

% peristimulus time histogram spike train (ideally, this is close to binary)
spike_trains    = cell(size(epoch_times, 1), 1);

% set the CMBHOME.Session epochs
% to be from the start of each light epoch
% to the end of each dark epoch
root.epoch      = epoch_times(:, [1, 3]);

% get the spike trains
for ii = 1:length(spike_trains)
    timestamps{ii} = root.ts{ii} - epoch_times(ii, 2);
    spike_trains{ii} = getSpikeTrain(root.cel_ts{ii}, root.ts{ii});
end

%% Visualize

% plot the raw spike trains
figure;
hold on
cmat = colormaps.linspecer(length(spike_trains));

for ii = 1:length(spike_trains)
    stairs(timestamps{ii}, spike_trains{ii}, 'Color', cmat(ii, :))
end

xlabel('time (s)')
ylabel('spike train')
figlib.pretty('PlotBuffer', 0.1)

% plot spike trains smoothed with a filter
% filter is a 20-second boxcar
this_filter = ones(1000, 1);
this_filter = this_filter / sum(this_filter);

filtered_spike_trains = cell(size(spike_trains, 1), 1);
for ii = 1:length(spike_trains)
    filtered_spike_trains{ii} = NeuralDecoder.encode(spike_trains{ii}, this_filter);
end

figure;
hold on
cmat = colormaps.linspecer(length(spike_trains));

for ii = 1:length(spike_trains)
    stairs(timestamps{ii}, filtered_spike_trains{ii}, 'Color', cmat(ii, :))
end

xlabel('time (s)')
ylabel('firing rate (a.u.)')
figlib.pretty('PlotBuffer', 0.1)
