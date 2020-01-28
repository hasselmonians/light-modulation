function data_table = getSpikeSpace(root)

  % accepts a CMBHOME.Session object (with root.cel defined)
  % and returns an n x 3 table
  % of the (t, x, y)-coordinates for all spikes

  % extract time-series vectors
  t = root.ts;
  x = root.sx;
  y = root.sy;
  spike_times = CMBHOME.Utils.ContinuizeEpochs(root.cel_ts);

  % which timestamp indices correspond to the spike times?
  [~, ~, bindices] = histcounts(spike_times, t);

  % retain only the values of the time series at spike times
  t = t(bindices);
  x = x(bindices);
  y = y(bindices);

  % assemble these vectors into a data table
  % remove missing entries (where x and y aren't available)
  data_table = rmmissing(table(t, x, y));
