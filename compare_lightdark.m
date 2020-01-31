%% compare adjacent epochs of light and darkness

% acquire the sample raw data
[root, light_on, light_off] = loadLightDarkCell();

% acquire the epoch sets
epoch_sets = getEpochs(light_on, light_off, 'MinEpochDuration', 100);

%% Compare adjacent epochs
% in light/dark conditions

% epoch_sets = [epoch_sets{:}];

% mean firing rate
mean_firing_rate = NaN(length(epoch_sets{1}), 2);

for ii = 1:length(epoch_sets)
    for qq = 1:2
        % set the epoch to the correct one
        root.epoch = epoch_sets{qq}(ii, :);

        % compute the firing rate in Hz
        mean_firing_rate(ii, qq) = length(root.cel_ts) / diff(epoch_sets{qq}(ii, :));
    end
end
