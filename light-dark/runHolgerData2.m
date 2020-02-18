r               = RatCatcher;
r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster2';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster2';
r.protocol      = 'LightDark2';
r.expID         = 'Holger';
r.project       = 'hasselmogrp';
r.verbose       = true;
r.mode          = 'singular';

%% Construct filename and filecode lists

% load the raw data from the cluster
data = load('/mnt/hasselmogrp/ahoyland/data/holger/data-Holger-LightDark.mat');

% filter the raw data
filtered_data_table = filterDataTable(data.data_table, ...
    'p', 0.05, ...
    'Modulation', 'positive', ...
    'Mode', 'l2d');

% use filenames and filecodes from the filtered data table
r.filenames     = filtered_data_table.filenames;
r.filecodes     = filtered_data_table.filecodes;

return

r.batchify

%% Post-processing

data_table = LightDark2.gather(r);

%% Save results

save('~/code/grid-cell-spiking/data/data-Holger-LightDark2.mat', 'data_table', 'r');
!cp ~/code/grid-cell-spiking/data/data-Holger-LightDark2.mat /mnt/hasselmogrp/ahoyland/data/holger/
