%% Make figures for LightDark2 protocol
% run on all 4 conditions.

% conditions
conditions_LightDark = { ...
      '1: p = 0.01, modulation = positive', ...
      '2: p = 0.05, modulation = positive', ...
      '3: p = 0.01, modulation = negative', ...
      '4: p = 0.05, modulation = negative'};

conditions_DarkLight = { ...
    '1: p = 0.01, modulation = negative', ...
    '2: p = 0.05, modulation = negative', ...
    '3: p = 0.01, modulation = positive', ...
    '4: p = 0.05, modulation = positive'};

for ii = 1:4

      %% LightDark %%

      load(['~/code/light-modulation/data/data-Holger-LightDark2-' num2str(ii) '.mat']);

      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      fig_handles(2*ii-1) = figure;
      hold on;
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);
      plot([0, 0], [-3, 3], '--k')
      text(-abs(zscored_timestamps(1)/2), 3, 'Light');
      text(abs(zscored_timestamps(1)/2), 3, 'Dark');
      xlabel('time (s)')
      xticks(zscored_timestamps(1):20:zscored_timestamps(end));
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          'Light to Dark'; ...
          conditions_LightDark{ii}})
      figlib.pretty('PlotBuffer', 0.1);
      set(gcf,'units','normalized','outerposition',[0 0 1 1])

      % % z-scored mean binned spike count (over all combined epochs & cells)
      % fig_handles(2*ii) = figure;
      % hold on;
      % plot(zscored_timestamps, zscored_spike_counts);
      % plot([0, 0], [-3, 3], '--k')
      % text(-abs(zscored_timestamps(1)/2), 3, 'Light');
      % text(abs(zscored_timestamps(1)/2), 3, 'Dark');
      % xlabel('time (s)')
      % ylabel('z-scored firing rate (a.u.)')
      % title({'z-scored mean binned spike counts (over all cells)'; ...
      %     'Light to Dark'; ...
      %     conditions_LightDark{ii}})
      % figlib.pretty('PlotBuffer', 0.1);
      % set(gcf,'units','normalized','outerposition',[0 0 1 1])

      %% DarkLight %%

      load(['~/code/light-modulation/data/data-Holger-DarkLight2-' num2str(ii) '.mat']);

      [zscored_spike_counts, zscored_timestamps] = averageOverEpochsCells(data_table);

      [vec_mean, vec_std] = averageOverNaNs(zscored_spike_counts);

      fig_handles(2*ii-1) = figure;
      hold on;
      plotlib.shadedErrorBar(zscored_timestamps, vec_mean, vec_std);
      plot([0, 0], [-3, 3], '--k')
      text(-abs(zscored_timestamps(1)/2), 3, 'Dark');
      text(abs(zscored_timestamps(1)/2), 3, 'Light');
      xlabel('time (s)')
      xticks(zscored_timestamps(1):20:zscored_timestamps(end));
      ylabel('z-scored firing rate (a.u.)')
      title({'z-scored mean binned spike counts (over all cells)'; ...
          'Dark to Light'; ...
          conditions_DarkLight{ii}})
      figlib.pretty('PlotBuffer', 0.1);
      set(gcf,'units','normalized','outerposition',[0 0 1 1])

      % % z-scored mean binned spike count (over all combined epochs & cells)
      % fig_handles(2*ii) = figure;
      % hold on;
      % plot(zscored_timestamps, zscored_spike_counts);
      % plot([0, 0], [-3, 3], '--k')
      % text(-abs(zscored_timestamps(1)/2), 3, 'Dark');
      % text(abs(zscored_timestamps(1)/2), 3, 'Light');
      % xlabel('time (s)')
      % ylabel('z-scored firing rate (a.u.)')
      % title({'z-scored mean binned spike counts (over all cells)'; ...
      %     'Dark to Light'; ...
      %     conditions_DarkLight{ii}})
      % figlib.pretty('PlotBuffer', 0.1);
      % set(gcf,'units','normalized','outerposition',[0 0 1 1])
end
