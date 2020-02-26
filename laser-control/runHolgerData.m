r               = RatCatcher;
r.localpath     = '/mnt/hasselmogrp/ahoyland/light-modulation/laser-control/cluster';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/light-modulation/laser-control/cluster';
r.protocol      = 'LaserControl';
r.expID         = 'Holger';
r.project       = 'hasselmogrp';
r.verbose       = true;
r.mode          = 'singular';

r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/laser-control/filenames.txt';
r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/laser-control/filecodes.csv';

return

r.batchify

return

data_table = r.gather;
