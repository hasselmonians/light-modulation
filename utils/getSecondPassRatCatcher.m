function r = getSecondPassRatCatcher(protocol, condition_number)

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
    %   protocol: character vector, either 'LightDark' or 'DarkLight'
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
    %   r = getSecondPassRatCatcher(protocol, condition_number);
    %
    % See Also: getFirstPassRatCatcher

    %% Preamble

    assert(any(strcmp(protocol, {'LightDark', 'DarkLight'})), ...
        'protocol must be either ''DarkLight'' or ''LightDark''')

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

    r                   = RatCatcher;

    switch protocol
    case 'LightDark'
        r.localpath     = '/mnt/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-LightDark2';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-LightDark2';
        r.protocol      = 'LightDark2';
    case 'DarkLight'
        r.localpath     = '/mnt/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-DarkLight2';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-DarkLight2';
        r.protocol      = 'DarkLight2';
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
