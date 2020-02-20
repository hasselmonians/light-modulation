function r = getFirstPassRatCatcher(protocol)

    %% Description:
    %   Generates a RatCatcher object for running one of the LightDark or DarkLight
    %   experiments in the first-pass.
    %
    % NOTE: This function assumes that the SCC is mounted at /mnt/hasselmogrp
    % There are hard-coded paths in this function.
    %
    %% Arguments:
    %   protocol: character vector, either 'LightDark' or 'DarkLight'
    %
    %% Outputs:
    %   r: a RatCatcher object
    %
    %% Examples:
    %   r = getFirstPassRatCatcher(protocol);
    %
    % See Also: getSecondPassRatCatcher

    %% Preamble

    assert(any(strcmp(protocol, {'LightDark', 'DarkLight'})), ...
        'protocol must be either ''DarkLight'' or ''LightDark''')

    %% Instantiate the RatCatcher object

    r                   = RatCatcher;

    switch protocol
    case 'LightDark'
        r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster-LightDark';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster-LightDark';
        r.protocol      = 'LightDark';
        r.expID         = 'Holger';
        r.project       = 'hasselmogrp';
        r.verbose       = true;
        r.mode          = 'singular';

        r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
        r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';
    case 'DarkLight'
        r               = RatCatcher;
        r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster-DarkLight';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster-DarkLight';
        r.protocol      = 'DarkLight';
        r.expID         = 'Holger';
        r.project       = 'hasselmogrp';
        r.verbose       = true;
        r.mode          = 'singular';

        r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
        r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';
    end

    % define other properties that don't depend on the protocol
    r.expID             = 'Holger';
    r.project           = 'hasselmogrp';
    r.verbose           = true;
    r.mode              = 'singular';

    % define the batchname using the condition number
    r.batchname     = [r.expID, '-', r.protocol, '-', num2str(condition_number)];

    %% Construct filename and filecode lists

    % load the raw data from the cluster
    switch protocol
    case 'LightDark'
        data = load('/mnt/hasselmogrp/ahoyland/data/holger/data-Holger-LightDark.mat');
    case 'DarkLight'
        data = load('/mnt/hasselmogrp/ahoyland/data/holger/data-Holger-DarkLight.mat');
    end

    % filter the raw data
    filtered_data_table = filterDataTable(data.data_table, ...
        'p', p, ...
        'Modulation', modulation, ...
        'Mode', 'both');

    % use filenames and filecodes from the filtered data table
    r.filenames     = filtered_data_table.filenames;
    r.filecodes     = filtered_data_table.filecodes;

end % function
