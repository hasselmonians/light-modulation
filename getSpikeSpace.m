function data_table = getSpikeSpace(root)

  % accepts a CMBHOME.Session object (with root.cel defined)
  % and returns an n x 3 matrix
  % of spikes and their (t, x, y) coordinates.

  % extract time-series vectors
  t = root.ts;
  x = root.sx;
  y = root.sy;
  spike_times = CMBHOME.Utils.ContinuizeEpochs(root.cel_ts);

  % reconstruct a binary spike train
  spike_train = false(length(t), 1);

  % which timestamp indices correspond to the spike times?
  [~, ~, bindices] = histcounts(spike_times, t);

  % retain only the values of the time series at spike times
  t = t(bindices);
  x = x(bindices);
  y = y(bindices);

  % assemble these vectors into a data table
  data_table = rmmissing(table(t, x, y));
