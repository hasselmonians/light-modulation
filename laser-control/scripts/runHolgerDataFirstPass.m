protocol = 'LaserControl';
% protocol = 'ControlLaser';

r = getFirstPassRatCatcher(protocol);

return

r.batchify

return

data_table = r.gather;
data_table = r.stitch(data_table);

return

save([['~/code/light-modulation/data/data-Holger-' r.protocol '.mat']], 'data_table', 'r');
% !cp ~/code/light-modulation/data/data-Holger-LaserControl.mat /mnt/hasselmogrp/ahoyland/data/holger/
