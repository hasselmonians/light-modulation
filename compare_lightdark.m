%% compare adjacent epochs of light and darkness

% acquire the sample raw data
[root, light_on, light_off] = loadLightDarkCell();

% acquire the epoch sets
[epoch_sets, keep_these] = getEpochs(light_on, light_off, 'MinEpochDuration', 100);

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

% get the mean firing rate differences and pairwise t-tests
[light2dark, dark2light, ttest_light2dark, ttest_dark2light] = getLightDarkStats(mean_firing_rate);

%% Visualize

figure;
boxplot([light2dark dark2light])
xlabel('conditions')
xticklabels({'light minus dark', 'recovery light minus dark'})
ylabel('mean firing rate difference (Hz)')
figlib.pretty('PlotBuffer', 0.1)

%% Visualize adjacent light-dark-light triplets

% reorder the firing rate into: light | dark | light
% the third column is just the first column shifted by one index forward
mean_firing_rate_LDL = [mean_firing_rate NaN(size(mean_firing_rate, 1), 1)];
mean_firing_rate_LDL(1:end-1, 3) = mean_firing_rate_LDL(2:end, 1);

figure;
plot(1:3, mean_firing_rate_LDL, 'k-o')
ylabel('mean firing rate (Hz)')
xticks([1, 2, 3]);
xticklabels({'light', 'dark', 'light'})

figlib.pretty('PlotBuffer', 0.1);

figure;
plot(1:3, mean_firing_rate_LDL ./ mean_firing_rate(:, 1), 'k-o')
ylabel('mean firing rate (norm.)')
xticks([1, 2, 3]);
xticklabels({'light', 'dark', 'light'})

figlib.pretty('PlotBuffer', 0.1);
