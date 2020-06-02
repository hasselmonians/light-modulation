function init(isCluster)

    % sets the MATLAB path for the light-modulation project

    if ~exist('isCluster', 'var')
        isCluster = false;
    end

    % e.g. ~/code
    code_dir = pathlib.strip(mfilename('fullpath'), 3);

    if isCluster
        addpath /projectnb/hasselmogrp/ahoyland/scripts
        addpath /projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools
        addpath /projectnb/hasselmogrp/ahoyland/light-modulation
        addpath /projectnb/hasselmogrp/ahoyland/light-modulation/head-direction
        addpath /projectnb/hasselmogrp/ahoyland/light-modulation/utils
        addpath /projectnb/hasselmogrp/ahoyland/light-modulation/scripts
        addpath /projectnb/hasselmogrp/ahoyland/RatCatcher
        addpath /projectnb/hasselmogrp/ahoyland/RatCatcher/scripts
        addpath /projectnb/hasselmogrp/ahoyland/CMBHOME
    else
        addpath(code_dir)
        addpath(fullfile(code_dir, 'srinivas.gs_mtools'))
        addpath(fullfile(code_dir, 'light-modulation'))
        addpath(fullfile(code_dir, 'light-modulation', 'head-direction'))
        addpath(fullfile(code_dir, 'light-modulation', 'utils'))
        addpath(fullfile(code_dir, 'light-modulation', 'scripts'))
	addpath(fullfile(code_dir, 'RatCatcher'))
	addpath(fullfile(code_dir, 'RatCatcher', 'scripts'))
	addpath(fullfile(code_dir, 'CMBHOME'))
    end
