%% LightDark %%

r = getSecondPassRatCatcher('LightDark');

return

%% Run on the cluster

r.batchify

return

%% Post-processing

data_table = LightDark2.gather(r);
data_table = r.stitch(data_table);

%% Save results

save('~/code/grid-cell-spiking/data/data-Holger-LightDark2.mat', 'data_table', 'r');
!cp ~/code/grid-cell-spiking/data/data-Holger-LightDark2.mat /mnt/hasselmogrp/ahoyland/data/holger/

%% DarkLight %%

r = getSecondPassRatCatcher('DarkLight');

return

%% Run on the cluster

r.batchify

return

%% Post-processing

data_table = LightDark2.gather(r);
data_table = r.stitch(data_table);

%% Save results

save('~/code/grid-cell-spiking/data/data-Holger-DarkLight2.mat', 'data_table', 'r');
!cp ~/code/grid-cell-spiking/data/data-Holger-DarkLight2.mat /mnt/hasselmogrp/ahoyland/data/holger/
