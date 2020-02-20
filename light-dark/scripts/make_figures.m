%% Make figures for LightDark2 protocol
% run on all 4 conditions.

% conditions
conditions = { ...
      '1: p = 0.01, modulation = positive', ...
      '2: p = 0.05, modulation = positive', ...
      '3: p = 0.01, modulation = negative', ...
      '4: p = 0.05, modulation = negative'};


for ii = 1:length(conditions)

      %% LightDark %%

      load(['~/code/grid-cell-spiking/data/data-Holger-LightDark2-' num2str(ii) '.mat']);

      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      fig_handles(2*ii-1) = figure;
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          conditions{ii}})
      figlib.pretty('PlotBuffer', 0.1);

      % z-scored mean binned spike count (over all combined epochs & cells)
      fig_handles(2*ii) = figure;
      plot(zscored_timestamps, zscored_spike_counts);
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          conditions{ii}})
      figlib.pretty('PlotBuffer', 0.1);

      %% DarkLight %%

      load(['~/code/grid-cell-spiking/data/data-Holger-DarkLight2-' num2str(ii) '.mat']);

      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      fig_handles(2*ii-1) = figure;
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          conditions{ii}})
      figlib.pretty('PlotBuffer', 0.1);

      % z-scored mean binned spike count (over all combined epochs & cells)
      fig_handles(2*ii) = figure;
      plot(zscored_timestamps, zscored_spike_counts);
      xlabel('time (s)')
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          conditions{ii}})
      figlib.pretty('PlotBuffer', 0.1);
end
