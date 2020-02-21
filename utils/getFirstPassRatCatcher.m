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
        r.localpath     = '/mnt/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-LightDark';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-LightDark';
        r.protocol      = 'LightDark';
        r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
        r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';
    case 'DarkLight'
        r               = RatCatcher;
        r.localpath     = '/mnt/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-DarkLight';
        r.remotepath    = '/projectnb/hasselmogrp/ahoyland/light-modulation/light-dark/cluster-DarkLight';
        r.protocol      = 'DarkLight';
        r.filenames     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filenames.txt';
        r.filecodes     = '/mnt/hasselmogrp/ahoyland/data/holger/light-dark/filecodes.csv';
    end

    % define other properties that don't depend on the protocol
    r.expID             = 'Holger';
    r.project           = 'hasselmogrp';
    r.verbose           = true;
    r.mode              = 'singular';

end % function
