%% compare adjacent epochs of light and darkness

% acquire the sample raw data
[root, light_on, light_off] = loadLightDarkCell();

% acquire the epoch sets
epoch_sets = getEpochs(light_on, light_off, 'MinEpochDuration', 100);

%% Compare adjacent epochs
% in light/dark conditions

% mean firing rate
mean_firing_rate = NaN(length(epoch_sets{1}), 2); % Hz

for ii = 1:2 % over both experimental conditions
    % gather all of the spike times for each of the epochs of that condition
    root.epoch = epoch_sets{ii};
    % iterate through the epochs and compute the mean firing rate
    % by number of spikes per unit time
    for qq = 1:size(root.epoch, 1)
        mean_firing_rate(qq, ii) = length(root.cel_ts{qq}) / diff(epoch_sets{ii}(qq, :));
    end
end
