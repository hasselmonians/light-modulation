function [lightONs, lightOFFs] = test_function(location, batchname, outfile, test)

    if ~test
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME'))
      addpath(genpath('/projectnb/hasselmogrp/ahoyland/grid-cell-spiking'))
    end

    %% Load the raw data

    % acquire all filenames and filecodes
    [filenames, filecodes] = RatCatcher.read([], location, batchname);

    %% Gather all of the light/dark epoch times

    lightONs = zeros(0, 2);
    lightOFFs = zeros(0, 2);

    parfor index = 1:length(filenames)
        % corelib.textbar(index, length(filenames))
        if test
            this = load(strrep(filenames{index}, 'projectnb', 'mnt'));
        else
            this = load(filenames{index});
        end

        % extract individual variables
        root = this.root;
        lightON = this.lightON;
        lightOFF = this.lightOFF;
        this = [];
        
        lightONs = [lightONs; lightON];
        lightOFFs = [lightOFFs; lightOFF];
    end

    return

end % function
