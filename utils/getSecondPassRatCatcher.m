function r = getSecondPassRatCatcher(condition_number)

    %% Description:
    %   Generates a RatCatcher object for running one of four conditions
    %   in the LightDark experiment second-pass.
    %   The conditions vary by the p-value confidence of light-modulation
    %   and whether this modulation is positive or negative.
    %
    % NOTE: This function assumes that the SCC is mounted at /mnt/hasselmogrp
    % There are hard-coded paths in this function.
    %
    %% Arguments:
    %   condition_number: numerical scalar, an integer 1-4
    %       1: p = 0.01, modulation = positive
    %       2: p = 0.05, modulation = positive
    %       3: p = 0.01, modulation = negative
    %       4: p = 0.05, modulation = negative
    %
    %% Outputs:
    %   r: a RatCatcher object
    %
    %% Examples:
    %   r = getSecondPassRatCatcher(1);
    %
    % See Also: RatCatcher.batchify

    %% Preamble

    switch condition_number
    case 1
        p = 0.01;
        modulation = 'positive';
    case 2
        p = 0.05;
        modulation = 'positive';
    case 3
        p = 0.01;
        modulation = 'negative';
    case 4
        p = 0.05;
        modulation = 'negative';
    otherwise
        error('condition_number should be an integer between 1 and 4')
    end

    %% Instantiate the RatCatcher object

    r               = RatCatcher;
    r.localpath     = '/mnt/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster2';
    r.remotepath    = '/projectnb/hasselmogrp/ahoyland/grid-cell-spiking/light-dark/cluster2';
    r.protocol      = 'LightDark2';
    r.expID         = 'Holger';
    r.project       = 'hasselmogrp';
    r.verbose       = true;
    r.mode          = 'singular';

    % define the batchname using the condition number
    r.batchname     = [r.expID, '-', r.protocol, '-', num2str(condition_number)];

    %% Construct filename and filecode lists

    % load the raw data from the cluster
    data = load('/mnt/hasselmogrp/ahoyland/data/holger/data-Holger-LightDark.mat');

    % filter the raw data
    filtered_data_table = filterDataTable(data.data_table, ...
        'p', p, ...
        'Modulation', modulation, ...
        'Mode', 'both');

    % use filenames and filecodes from the filtered data table
    r.filenames     = filtered_data_table.filenames;
    r.filecodes     = filtered_data_table.filecodes;

end % function