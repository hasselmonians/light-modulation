% set up jobs on the cluster for all four conditions
% gather the data afterwards
% save the data and copy to cluster

%% LightDark %%

%% Instantiate the RatCatcher objects

for ii = 4:-1:1
    rc(ii) = getSecondPassRatCatcher('LightDark', ii);
    rc(ii) = rc(ii).validate;
end

return

%% Batch the jobs

for ii = 1:4
    rc(ii).batchify;
end

return

%% Gather the output data

for ii = 1:4
    r = rc(ii);
    data_table = LightDark2.gather(r);
    data_table = r.stitch(data_table);
    save_filepath = '~/code/grid-cell-spiking/data/data-';
    save([save_filepath, r.batchname], 'data_table', 'r');
end

return

%% Copy to cluster

!cp ~/code/grid-cell-spiking/data/data* /mnt/hasselmogrp/ahoyland/data/holger/
