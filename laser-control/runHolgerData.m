r               = RatCatcher;
r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/laser-control/cluster';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/laser-control/cluster';
r.protocol      = 'LaserControl';
r.expID         = 'Holger';
r.project       = 'hasselmogrp';
r.verbose       = true;
r.mode          = 'singular';

return

% r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
% r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';

return

r.batchify

return

data_table = r.gather;
