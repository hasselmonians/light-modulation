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

save(['~/code/light-modulation/data/data-', r.batchname, '.mat'], 'data_table', 'r');
% !cp ~/code/light-modulation/data/data-Holger-PROTOCOL.mat /mnt/hasselmogrp/ahoyland/data/holger/
