r               = RatCatcher;
r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster';
r.protocol      = 'LightDark';
r.expID         = 'Holger';
r.project       = 'hasselmogrp';
r.verbose       = true;
r.mode          = 'singular';

r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';

disp(r)

response = input(['Do you want to begin batching? Y/N [Y]: '], 's');

if isempty(response)
    response = 'Y';
end

if strcmp(response, {'yes', 'Yes', 'Y', 'y'})
    r = r.batchify;
    disp(r)
else
    r = r.validate;
    disp(r)
end
