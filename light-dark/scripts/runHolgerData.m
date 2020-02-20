protocol = 'LightDark';

r = getFirstPassRatCatcher(protocol);

return

%% Run on the cluster

r = r.batchify();

return

%% Post-processing

data_table = r.gather();
data_table = r.stitch(data_table);

%% Save results

save(['~/code/grid-cell-spiking/data/data-', r.batchname, '.mat'], 'data_table', 'r');
% !cp ~/code/grid-cell-spiking/data/data-Holger-PROTOCOL.mat /mnt/hasselmogrp/ahoyland/data/holger/
