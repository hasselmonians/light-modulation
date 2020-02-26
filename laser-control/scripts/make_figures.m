%% Make figures for LaserControl protocol
% run on all 4 conditions.

% conditions for filtering the first-pass results
conditions = { ...
      '1: p = 0.01, modulation = positive', ...
      '2: p = 0.05, modulation = positive', ...
      '3: p = 0.01, modulation = negative', ...
      '4: p = 0.05, modulation = negative'};

for ii = 1:4

      %% LaserControl %%

      % load the raw data
      % you need to change this path
      load(['~/code/light-modulation/data/data-Holger-LaserControl2-' num2str(ii) '.mat']);

      % acquire z-score the raw data
      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      % acquire the mean and standard deviation over all cells
      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      % create a figure
      fig_handles(2*ii-1) = figure;
      hold on;

      % plot the mean with a standard deviation shaded error
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);

      % plot a dashed line at x = 0
      plot([0, 0], [-3, 3], '--k')

      % add text labels
      text(-abs(zscored_timestamps(1)/2), 3, 'Light');
      text(abs(zscored_timestamps(1)/2), 3, 'Dark');

      % axis labels and titles
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
      'Light to Dark'; ...
      conditions{ii}})

      % post-processing
      figlib.pretty('PlotBuffer', 0.1, 'XMinorTicks', true);
      set(gcf,'units','normalized','outerposition',[0 0 1 1])

      %% ControlLaser %%

      load(['~/code/light-modulation/data/data-Holger-ControlLaser2-' num2str(ii) '.mat']);

      % acquire z-score the raw data
      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      % acquire the mean and standard deviation over all cells
      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      % create a figure
      fig_handles(2*ii-1) = figure;
      hold on;

      % plot the mean with a standard deviation shaded error
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);

      % plot a dashed line at x = 0
      plot([0, 0], [-3, 3], '--k')

      % add text labels
      text(-abs(zscored_timestamps(1)/2), 3, 'Light');
      text(abs(zscored_timestamps(1)/2), 3, 'Dark');

      % axis labels and titles
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
      'Light to Dark'; ...
      conditions{ii}})

      % post-processing
      figlib.pretty('PlotBuffer', 0.1, 'XMinorTicks', true);
      set(gcf,'units','normalized','outerposition',[0 0 1 1])

end
